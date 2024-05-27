import 'package:flutter/material.dart';
import 'package:kairos/models/auction.dart';

class AddAuction extends StatefulWidget {
  final String loginUserEmail;
  const AddAuction({super.key, required this.loginUserEmail});

  @override
  State<AddAuction> createState() => _AddAuctionState();
}

class _AddAuctionState extends State<AddAuction> {
  final TextEditingController _watchIdController = TextEditingController();
  final AuctionRepository _auctionRepository = AuctionRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Subasta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _watchIdController,
              decoration: const InputDecoration(labelText: 'ID del Reloj'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addAuction,
              child: const Text('Crear Subasta'),
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
            title: const Text('Campos faltantes'),
            content: const Text('Por favor ingrese el ID del reloj.'),
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
          salerEmail: widget.loginUserEmail,
          buyerEmail: '-',
          purchaseDate: DateTime.now(),
          auctionStatus: 'Activa',
          watchId: watchId,
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reloj registrado correctamente'),
            content: const Text('Reloj registrado correctamente'),
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
            content: Text('Error al registrar la subasta: $e'),
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
