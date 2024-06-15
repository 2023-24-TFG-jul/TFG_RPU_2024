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
  late int _minimumValueController;
  late int _maximumValueController;
  
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
              decoration: const InputDecoration(labelText: 'Minimum price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _minimumValueController = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 20.0),
                        TextField(
              decoration: const InputDecoration(labelText: 'Maximum price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _maximumValueController = int.tryParse(value) ?? 0;
              },
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
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedDate = DateTime(
          limitDate.year,
          limitDate.month,
          limitDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }
}


  void _addAuction() async {
    
    String watchNickName = _watchNickNameController.text;
    int minimumValue = _minimumValueController;
    int maximumValue = _maximumValueController;

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
          limitDate: _selectedDate!,  // no puede ser nulo -> !
          auctionStatus: 'Active',
          watchNickName: watchNickName,
          minimumValue: minimumValue,
          actualValue: 0, // empieza en 0 porque puede que no compre nadie, pero la apuesta es la minima
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
