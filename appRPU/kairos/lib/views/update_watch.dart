import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';

class UpdateWatch extends StatefulWidget {
  final String watchNickName;

  const UpdateWatch({super.key, required this.watchNickName});

  @override
  State<UpdateWatch> createState() => _UpdateWatchState();
}

class _UpdateWatchState extends State<UpdateWatch> {
  final TextEditingController _conditionController = TextEditingController();

  late int _priceController = 0;

  final WatchRepository _watchRepository = WatchRepository();

  final List<String> _condition = [
    'Fair',
    'Good',
    'Incomplete',
    'New',
    'Poor',
    'Unworn',
    'Very good'
  ];

  String? _selectedCondition;

  @override
  void initState() {
    super.initState();
    _loadWatchData();
  }

  Future<void> _loadWatchData() async {
    try {
      Watch watch =
          await _watchRepository.getWatchByNickname(widget.watchNickName);
      setState(() {
        _conditionController.text = watch.condition;
        _priceController = watch.price;
      });
    } catch (e) {
      _showDialog('Error', 'Error loading watch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Your Watch Data'),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCondition,
                      items: _condition.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCondition = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'New condition *',
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
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'New price',
                              hintStyle: TextStyle(
                                  fontSize: isLargeScreen ? 18.0 : 14.0),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _priceController = int.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.euro),
                          onPressed: () {
                            // predict price
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _updateWatch,
                      child: const Text('Update'),
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

  void _updateWatch() async {
    String newCondition = _selectedCondition ?? '';
    int newPrice = _priceController;

    if (newCondition.trim().isEmpty) {
      _showDialog('Missing fields', 'Please complete "New condition" fields.');
      return;
    }

    if (newCondition == 'null') {
      // control para no inyectar null
      _showDialog(
          'Invalid fields', 'The field "New condition" cannot be null.');
      return;
    }

    if (newPrice < 0) {
      _showDialog(
          'Invalid price', 'Please enter an integer and positive price.');
      return;
    }

    try {
      await _watchRepository.updateWatch(
          widget.watchNickName, newCondition, newPrice);
      _showDialog('Update Successful', 'Your watch data has been updated.');
    } catch (e) {
      _showDialog('Error', 'Error updating user: $e');
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
