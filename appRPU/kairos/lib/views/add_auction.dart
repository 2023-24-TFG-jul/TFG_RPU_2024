import 'package:flutter/material.dart';
import 'package:kairos/models/auction.dart';
import 'package:kairos/models/watch.dart';

class AddAuction extends StatefulWidget {
  final String loginUserEmail;
  const AddAuction({super.key, required this.loginUserEmail});

  @override
  State<AddAuction> createState() => _AddAuctionState();
}

class _AddAuctionState extends State<AddAuction> {
  final TextEditingController _watchIdController = TextEditingController();
  final AuctionRepository _auctionRepository = AuctionRepository();
  final WatchRepository _watchRepository = WatchRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create auction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _watchIdController,
              decoration: const InputDecoration(labelText: 'Watch ID'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addAuction,
              child: const Text('Create auction'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAuction() async {
    String watchId = _watchIdController.text;

    if (watchId.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing fields'),
            content: const Text('Please enter your watch ID.'),
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
      return;
    }

    try {
      await _auctionRepository.addAuction(
        Auction(
          idAuction: '',
          vendorEmail: widget.loginUserEmail,
          buyerEmail: '-',
          purchaseDate: DateTime.now(),
          auctionStatus: 'Activa',
          watchId: watchId,
        ),
      );

      await _watchRepository.updateWatch(watchId, 'At auction');  //cambio estado reloj

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Correct registration'),
            content: const Text('Auction registered correctly.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true); // se cierra el registro, se pasa a pantalla views actualizada
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error registering auction: $e'),
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
}
