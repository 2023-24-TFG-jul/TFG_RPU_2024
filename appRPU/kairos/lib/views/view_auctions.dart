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
    _auctionsFuture = _auctionRepository.getAllAuctionsWithStatusUploaded().then((auctions) async {
      for (var auction in auctions) {
        if (_isAuctionExpired(auction) && auction.auctionStatus != 'Finished') {
          auction.auctionStatus = 'Finished';
          await _watchRepository.updateSaleStatusWatch(auction.watchNickName, 'Purchased');
          await _auctionRepository.updateAuction(auction);
        }
      }
      return auctions;
    });
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
      await _auctionRepository.buyWatch(auctionId, loginUserEmail, auction.maximumValue);
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

  void _showBidDialog(Auction auction) {
    TextEditingController bidController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Place a bid'),
          content: TextField(
            controller: bidController,
            decoration: const InputDecoration(labelText: 'Bid Amount (€)'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String bidAmount = bidController.text;
                if (double.tryParse(bidAmount) != null) {
                  double newBid = double.parse(bidAmount);
                  if (newBid >= double.parse(auction.maximumValue)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You cannot exceed the maximum value.')),
                    );
                  } else if (newBid > double.parse(auction.actualValue) && newBid >= double.parse(auction.minimumValue)) {
                    auction.updateBid(newBid.toString());
                    auction.buyerEmail = loginUserEmail;
                    await _auctionRepository.updateAuction(auction);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bid of $bidAmount € placed successfully.')),
                    );
                    _loadAuctions(loginUserEmail);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bid must be higher than current value.')),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Place Bid'),
            ),
          ],
        );
      },
    );
  }

  bool _isAuctionExpired(Auction auction) {
    DateTime limitDate = auction.limitDate;
    return DateTime.now().isAfter(limitDate);
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
            return ListView.builder(
              itemCount: auctions.length,
              itemBuilder: (context, index) {
                Auction auction = auctions[index];
                bool isVendor = auction.vendorEmail == loginUserEmail;
                bool isExpired = _isAuctionExpired(auction);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(auction.watchNickName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vendor: ${auction.vendorEmail}'),
                        Text('Buyer: ${auction.buyerEmail}'),
                        Text('Start Value: ${auction.minimumValue}'),
                        Text('Actual Value: ${auction.actualValue}'),
                        Text('Direct Sale Price: ${auction.maximumValue}'),
                        Text('Limit Date: ${auction.limitDate}'),
                        Text('Status: ${auction.auctionStatus}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: isVendor && !isExpired && auction.auctionStatus != 'Finished'
                              ? () => _deleteAuction(auction.idAuction)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: !isVendor && !isExpired  && auction.auctionStatus != 'Finished'
                              ? () => _buyAuction(auction.idAuction)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.euro),
                          onPressed: !isVendor && !isExpired && auction.auctionStatus != 'Finished'
                              ? () => _showBidDialog(auction)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAuction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
