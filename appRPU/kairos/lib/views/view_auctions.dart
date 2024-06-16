import 'package:flutter/material.dart';
import 'package:kairos/models/auction.dart';
import 'package:kairos/models/user.dart';
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
  final UserRepository _userRepository = UserRepository();

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
      _auctionsFuture =
          _auctionRepository.getAllAuctions().then((auctions) async {
        for (var auction in auctions) {
          if (_isAuctionExpired(auction) &&
              auction.auctionStatus != 'Finished') {
            auction.auctionStatus = 'Finished';
            await _watchRepository.updateSaleStatusWatch(
                auction.watchNickName, 'Purchased');
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
      await _watchRepository.updateSaleStatusWatch(
          auction.watchNickName, 'Available');
      await _auctionRepository.deleteAuction(id);
      _loadAuctions(loginUserEmail);
    } catch (e) {
      _showDialog('Error', 'Error deleting auction: $e');
    }
  }

  void _buyAuction(String auctionId) async {
    try {
      Auction auction = await _auctionRepository.getAuctionById(auctionId);
      await _watchRepository.updateSaleStatusWatch(
          auction.watchNickName, 'Purchased');
      await _auctionRepository.buyWatch(
          auctionId, loginUserEmail, auction.maximumValue);
      await _auctionRepository.updateAuctionStatus(
          auction.watchNickName, 'Finished');
      await _userRepository.updateUserWallet(
          loginUserEmail, auction.maximumValue);
      await _userRepository.updateUserWallet(
          auction.vendorEmail, -auction.maximumValue); //para que sume
      _loadAuctions(loginUserEmail);
      _showDialog('Correct purchase', 'Watch successfully acquired.');
      return;
    } catch (e) {
      _showDialog('Bad purchase', 'Error when purchasing the watch: $e');
    }
  }

  void _showBidDialog(Auction auction) {
    late int _bidController;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Place a bid'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Bid Amount (€)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _bidController = int.tryParse(value) ?? 0;
            },
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
                int bidAmount = _bidController;
                if (bidAmount != 0) {
                  int newBid = bidAmount;
                  if (newBid >= auction.maximumValue) {
                    _showDialog('Invalid data', 'You cannot exceed the maximum value.');
                    return;
                  } else if (newBid > auction.actualValue &&
                      newBid >= auction.minimumValue) {
                    await _auctionRepository.updateBid(
                        auction.watchNickName, newBid, loginUserEmail);
                    _showDialog('Correct bid', 'Bid of $bidAmount € placed successfully.');
                    _loadAuctions(loginUserEmail);
                    return;
                  } else {
                    _showDialog('Invalid data', 'Bid must be higher than current value.');
                    return;
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/kairos_wallpaper.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Center(
            child: FutureBuilder<List<Auction>>(
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
                        margin:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(auction.watchNickName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRichText('Vendor:\n', auction.vendorEmail),
                              _buildRichText('Buyer:\n', auction.buyerEmail),
                              _buildRichText('Start Value:\n',
                                  auction.minimumValue.toString()),
                              _buildRichText('Actual Value:\n',
                                  auction.actualValue.toString()),
                              _buildRichText('Direct Sale Price:\n',
                                  auction.maximumValue.toString()),
                              _buildRichText(
                                  'Limit Date:\n', auction.limitDate.toString()),
                              _buildRichText('Status:\n', auction.auctionStatus),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: isVendor &&
                                        !isExpired &&
                                        auction.auctionStatus != 'Finished'
                                    ? () => _deleteAuction(auction.idAuction)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: !isVendor &&
                                        !isExpired &&
                                        auction.auctionStatus != 'Finished'
                                    ? () => _buyAuction(auction.idAuction)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.euro),
                                onPressed: !isVendor &&
                                        !isExpired &&
                                        auction.auctionStatus != 'Finished'
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAuction,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

    // Function defining the warning format of error messages.
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
