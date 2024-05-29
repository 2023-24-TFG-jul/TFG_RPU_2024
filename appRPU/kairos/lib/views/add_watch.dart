import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';

class AddWatch extends StatefulWidget {
  
  final String loginUserEmail;
  
  const AddWatch({super.key, required this.loginUserEmail});

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {
  final TextEditingController _watchNickNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _movementController = TextEditingController();
  final TextEditingController _casemController = TextEditingController();
  final TextEditingController _bracemController = TextEditingController();
  final TextEditingController _yopController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final WatchRepository _watchRepository = WatchRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register your watch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _watchNickNameController,
              decoration: const InputDecoration(labelText: 'Watch nickname'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _referenceController,
              decoration: const InputDecoration(labelText: 'Reference'),
            ),
            TextField(
              controller: _movementController,
              decoration: const InputDecoration(labelText: 'Movement'),
            ),
            TextField(
              controller: _casemController,
              decoration: const InputDecoration(labelText: 'Casem'),
            ),
            TextField(
              controller: _bracemController,
              decoration: const InputDecoration(labelText: 'Bracem'),
            ),
            TextField(
              controller: _yopController,
              decoration: const InputDecoration(labelText: 'Yop'),
            ),
            TextField(
              controller: _conditionController,
              decoration: const InputDecoration(labelText: 'Condition'),
            ),
            TextField(
              controller: _sexController,
              decoration: const InputDecoration(labelText: 'Sex'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addWatch,
              child: const Text('Add your watch'),
            ),
          ],
        ),
      ),
    );
  }

  void _addWatch() async {
    
    String watchNickName = _watchNickNameController.text;
    String brand = _brandController.text;
    String model = _modelController.text;
    String reference = _referenceController.text;
    String movement = _movementController.text;
    String casem = _casemController.text;
    String bracem = _bracemController.text;
    String yop = _yopController.text;
    String condition = _conditionController.text;
    String sex = _sexController.text;
    String price = _priceController.text;

    final yopRegex = RegExp(r'(\d+)');
    final sexRegex = RegExp(r'^(Women|Men/Unisex)$');
    final priceRegex = RegExp(r'^\d+(\.\d+)?$');

    if (!yopRegex.hasMatch(yop)) {
      _showDialog('Invalid yop', 'Please enter a year greater than zero.');
      return;
    }

    if (!sexRegex.hasMatch(sex)) {
      _showDialog('Invalid sex', 'Please enter "Women" or "Men/Unisex".');
      return;
    }

    if (!priceRegex.hasMatch(price)) {
      _showDialog('Invalid price', 'Please enter an integer and positive price.');
      return;
    }

    if (brand.isEmpty ||
        model.isEmpty ||
        yop.isEmpty ||
        condition.isEmpty) {
      _showDialog('Missing fields', 'Please complete all fields.');
      return;
    }

    // Watch existe?
    bool watchExists = await _watchRepository.checkWatchExists(watchNickName);
    if (watchExists) {
      _showDialog('Error', 'The watch already exists.');
      return;
    }

    if (brand == 'null' || model == 'null' || condition == 'null') { // control para no inyectar null
      _showDialog('Invalid fields', 'The fields brand, model and condition cannot be null.');
      return;
    }

    try {
      await _watchRepository.addWatch(Watch(
          id: '',
          watchNickName: watchNickName,
          brand: brand,
          model: model,
          reference: reference,
          movement: movement,
          casem: casem,
          bracem: bracem,
          yop: yop,
          condition: condition,
          sex: sex,
          price: price,
          saleStatus: 'Uploaded'), 
          widget.loginUserEmail
          );
      _showDialog('Registration successful', 'Watch successfully registered.');
    } catch (e) {
      _showDialog('Error', 'Error registering watch.: $e');
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
