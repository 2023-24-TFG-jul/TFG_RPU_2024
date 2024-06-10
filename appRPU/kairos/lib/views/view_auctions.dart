import 'package:flutter/material.dart';
import 'package:kairos/models/auction.dart';
import 'package:kairos/models/watch.dart';
import 'add_auction.dart';

class ViewAuctions extends StatefulWidget {
  const ViewAuctions({super.key});

  @override
  State<ViewAuctions> createState() => _ViewAuctionsState();
}

class _ViewAuctionsState extends State<ViewAuctions> {
  
  final AuctionRepository _auctionRepository = AuctionRepository();
  final WatchRepository _watchRepository = WatchRepository();

  late Future<List<Auction>> _auctionsFuture;
  late String loginUserEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadAuctions(loginUserEmail);
    });
  }

  void _loadAuctions(String email) {
    setState(() {
      _auctionsFuture = _auctionRepository.getAllAuctionsWithStatusUploaded();
    });
  }

  void _navigateToAddAuction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAuction(loginUserEmail: loginUserEmail),
      ),
    );
    _loadAuctions(loginUserEmail);
  }

  void _deleteAuction(String id) async {
    try {
      Auction auction = await _auctionRepository.getAuctionById(id);
      await _watchRepository.updateSaleStatusWatch(auction.watchNickName, 'Available');
      await _auctionRepository.deleteAuction(id);
      _loadAuctions(loginUserEmail);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting the auction: $e')),
      );
    }
  }

  void _buyAuction(String auctionId) async {
    try {
      Auction auction = await _auctionRepository.getAuctionById(auctionId);
      await _watchRepository.updateSaleStatusWatch(auction.watchNickName, 'Purchased');
      await _auctionRepository.buyWatch(auctionId, loginUserEmail);
      await _auctionRepository.updateAuctionStatus(auction.watchNickName, 'Finished');
      _loadAuctions(loginUserEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Watch successfully acquired.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error when purchasing the watch: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auctions'),
      ),
      body: FutureBuilder<List<Auction>>(
        future: _auctionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No auctions found.'));
          } else {
            List<Auction> auctions = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Watch Nickname')),
                  DataColumn(label: Text('Vendor')),
                  DataColumn(label: Text('Buyer')),
                  DataColumn(label: Text('Start Value')),
                  DataColumn(label: Text('Actual Value')),
                  DataColumn(label: Text('Direct sale price')),
                  DataColumn(label: Text('Limit Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: auctions.map((auction) {
                  bool isFinished = auction.auctionStatus == 'Finished';
                  return DataRow(cells: [
                    DataCell(Text(auction.watchNickName)),
                    DataCell(Text(auction.vendorEmail)),
                    DataCell(Text(auction.buyerEmail)),
                    DataCell(Text(auction.minimumValue)),
                    DataCell(Text(auction.actualValue)),
                    DataCell(Text(auction.maximumValue)),
                    DataCell(Text(auction.limitDate)),
                    DataCell(Text(auction.auctionStatus)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: isFinished ? null : () => _deleteAuction(auction.idAuction),
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: isFinished ? null : () => _buyAuction(auction.idAuction),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: _navigateToAddAuction,
      ),
    );
  }
}
