import 'package:flutter/material.dart';
import 'package:kairos/models/auction.dart';
import 'add_auction.dart';

class ViewAuctions extends StatefulWidget {
  const ViewAuctions({super.key});

  @override
  _ViewAuctionsState createState() => _ViewAuctionsState();
}

class _ViewAuctionsState extends State<ViewAuctions> {
  final AuctionRepository _auctionRepository = AuctionRepository();
  late Future<List<Auction>> _auctionsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadAuctions(loginUserEmail);
    });
  }

  void _loadAuctions(String loginUserEmail) {
    setState(() {
      _auctionsFuture = _auctionRepository.getAllAuctionsWithStatusSubido();
    });
  }

  void _navigateToAddAuction() async {
    final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
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
      await _auctionRepository.deleteAuction(id);
      final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadAuctions(loginUserEmail);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al borrar la subasta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subastas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddAuction,
          ),
        ],
      ),
      body: FutureBuilder<List<Auction>>(
        future: _auctionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron relojes'));
          } else {
            List<Auction> auctions = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Id del reloj')),
                  DataColumn(label: Text('Vendedor')),
                  DataColumn(label: Text('Comprador')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: auctions.map((auction) {
                  return DataRow(cells: [
                    DataCell(Text(auction.watchId)),
                    DataCell(Text(auction.salerEmail)),
                    DataCell(Text(auction.buyerEmail)),
                    DataCell(Text(auction.auctionStatus)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteAuction(auction.idAuction),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
