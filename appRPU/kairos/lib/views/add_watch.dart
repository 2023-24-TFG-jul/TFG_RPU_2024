import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';
import 'package:kairos/settings/csv_settings.dart';

class AddWatch extends StatefulWidget {
  final String loginUserEmail;

  const AddWatch({super.key, required this.loginUserEmail});

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {
  final TextEditingController _watchNickNameController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _yopController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final WatchRepository _watchRepository = WatchRepository();
  final CsvService _csvService = CsvService();

  List<Map<String, String>> _csvData = [];

  List<String> _brands = [];
  List<String> _models = [];

  final List<String> _mvmt = ['Automatic', 'Manual Winding'];
  final List<String> _casem = ['Aluminium', 'Bronze', 'Carbon', 'Ceramic', 'Gold/Steel', 'Palladium', 'Plastic', 'Platinum',
                               'Red gold', 'Rose gold', 'Silver', 'Steel', 'Tantalum', 'Titanium', 'Tungsten', 'White gold', 'Yellow gold'];
  final List<String> _bracem = ['Aluminium', 'Calf skin', 'Ceramic', 'Cocodrile skin', 'Gold/Steel', 'Leather', 'Lizard skin', 'Ostrich skin',
                                'Plastic', 'Platinum', 'Red gold', 'Rose gold', 'Rubber', 'Satin', 'Shark skin', 'Silicon', 'Silver',
                                'Snake skin', 'Steel', 'Textile', 'Titanium', 'White gold', 'Yellow gold'];
  final List<String> _condition = ['Fair', 'Good', 'Incomplete', 'New', 'Poor', 'Unworn', 'Very good'];
  final List<String> _sex = ["Men's watch/Unisex", "Women's watch"];

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedMvmt;
  String? _selectedCasem;
  String? _selectedBracem;
  String? _selectedCondition;
  String? _selectedSex;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  void _loadCsvData() async {
    List<Map<String, String>> data = await _csvService.loadCsvData('assets/database_watches.csv');
    setState(() {
      _csvData = data;
      _brands = data.map((e) => e['brand']!).toSet().toList();
    });
  }

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
              decoration: const InputDecoration(
                labelText: 'Watch nickname *',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedBrand,
              items: _brands.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedBrand = newValue;
                  _models = _getModelsForBrand(newValue);
                  _selectedModel = null;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Brand *',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedModel,
              items: _models.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Model *',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            TextField(
              controller: _referenceController,
              decoration: const InputDecoration(labelText: 'Reference'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedMvmt,
              items: _mvmt.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMvmt = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Movement',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCasem,
              items: _casem.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCasem = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Casem',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedBracem,
              items: _bracem.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedBracem = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Bracem',
              ),
            ),
            TextField(
              controller: _yopController,
              decoration: const InputDecoration(
                labelText: 'Yop *',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
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
              decoration: const InputDecoration(
                labelText: 'Condition *',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedSex,
              items: _sex.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSex = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Sex',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.euro),
                  onPressed: () {
                    // calculo prediccion
                  },
                ),
              ],
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

  List<String> _getModelsForBrand(String? brand) {
    if (brand == null) return [];
    return _csvData
        .where((element) => element['brand'] == brand)
        .map((element) => element['model']!)
        .toSet()
        .toList();
  }

  void _addWatch() async {
    String watchNickName = _watchNickNameController.text;
    String brand = _selectedBrand ?? '';
    String model = _selectedModel ?? '';
    String reference = _referenceController.text;
    String movement = _selectedMvmt ?? '';
    String casem = _selectedCasem ?? '';
    String bracem = _selectedBracem ?? '';
    String yop = _yopController.text;
    String condition = _selectedCondition ?? '';
    String sex = _selectedSex ?? '';
    String price = _priceController.text;

    final yopRegex = RegExp(r'(\d+)');
    final priceRegex = RegExp(r'^\d+(\.\d+)?$');

    if (!yopRegex.hasMatch(yop) || int.parse(yop) > DateTime.now().year) {
      _showDialog('Invalid yop', 'Please enter a year between zero and the actual year.');
      return;
    }

    if (!priceRegex.hasMatch(price)) {
      _showDialog('Invalid price', 'Please enter an integer and positive price.');
      return;
    }

    if (brand.isEmpty || model.isEmpty || yop.isEmpty || condition.isEmpty || watchNickName.isEmpty) {
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
      await _watchRepository.addWatch(
          Watch(
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
          widget.loginUserEmail);
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
