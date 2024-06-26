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

  final TextEditingController _watchNickNameController =
      TextEditingController();
  late int _minimumValueController = 0;
  late int _maximumValueController = 0;

  final AuctionRepository _auctionRepository = AuctionRepository();
  final WatchRepository _watchRepository = WatchRepository();

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Create auction')),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _watchNickNameController,
                      style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      decoration: InputDecoration(
                        hintText: 'Watch nickname *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Deadline for the end of the auction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isLargeScreen ? 20.0 : 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Enter your limit date',
                            style: TextStyle(
                                fontSize: isLargeScreen ? 18.0 : 14.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Minimum price *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _minimumValueController = int.tryParse(value) ?? 0;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Direct sale price *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _maximumValueController = int.tryParse(value) ?? 0;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _addAuction,
                      child: Text('Add new auction',
                          style:
                              TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

    if (watchNickName.trim().isEmpty) {
      _showDialog('Missing fields', 'Please enter your watch nickname.');
      return;
    }

    if (_selectedDate == null) {
      _showDialog('Date not chosen',
          'Please choose a date in order to create the auction.');
      return;
    }

    if (minimumValue >= maximumValue) {
      _showDialog('Invalid values',
          'The maximum value must be greater than the minimum value.');
      return;
    }

    if (minimumValue <= 0 || maximumValue <= 0) {
      _showDialog('Invalid values', 'Values must be greater than 0');
      return;
    }

    try {
      bool watchExists = await _watchRepository
          .existWatch(watchNickName); // we check if the watch exists

      if (!watchExists) {
        _showDialog('Error', 'There is no watch with this nickname');
        return;
      }

      await _auctionRepository.addAuction(
        Auction(
            idAuction: '',
            vendorEmail: widget.loginUserEmail,
            buyerEmail: '-',
            limitDate: _selectedDate!, // cannot be null
            auctionStatus: 'Active',
            watchNickName: watchNickName,
            minimumValue: minimumValue,
            actualValue:
                0, // start at 0 because no one may buy, but the bet is the minimum.
            maximumValue: maximumValue),
      );

      await _watchRepository.updateSaleStatusWatch(watchNickName, 'At auction');
      _showDialog('Correct registration', 'Auction registered correctly.');
    } catch (e) {
      _showDialog('Error', 'Error registering auction: $e');
    }
  }

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
