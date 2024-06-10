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
  
  DateTime? _selectedDate;
  
  final TextEditingController _watchNickNameController = TextEditingController();
  final TextEditingController _minimumValueController = TextEditingController();
  final TextEditingController _maximumValueController = TextEditingController();
  
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
              controller: _watchNickNameController,
              decoration: const InputDecoration(labelText: 'Watch Nickname'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _minimumValueController,
              decoration: const InputDecoration(labelText: 'Minimum price'),
            ),
            const SizedBox(height: 20.0),
                        TextField(
              controller: _maximumValueController,
              decoration: const InputDecoration(labelText: 'Maximum price'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate != null
                    ? 'Limit date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Enter limit date',
              ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? limitDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (limitDate != null) {
      setState(() {
        _selectedDate = limitDate;
      });
    }
  }

  void _addAuction() async {
    
    String watchNickName = _watchNickNameController.text;
    String minimumValue = _minimumValueController.text;
    String maximumValue = _maximumValueController.text;

    if (watchNickName.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing fields'),
            content: const Text('Please enter your watch nickname.'),
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
      
      bool watchExists = await _watchRepository.existWatch(watchNickName); //vemos si existe el reloj

      if (!watchExists) {  //si no existe el reloj, no crea
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('The watch nickname does not exist'),
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

      await _auctionRepository.addAuction(
        Auction(
          idAuction: '',
          vendorEmail: widget.loginUserEmail,
          buyerEmail: '-',
          purchaseDate: DateTime.now(),
          limitDate: "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
          auctionStatus: 'Active',
          watchNickName: watchNickName,
          minimumValue: '0',
          actualValue: minimumValue, // tiene que empezar en el valor minimo
          maximumValue: maximumValue
        ),
      );

      await _watchRepository.updateSaleStatusWatch(watchNickName, 'At auction');

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
