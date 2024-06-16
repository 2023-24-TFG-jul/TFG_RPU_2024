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
  final TextEditingController _watchNickNameController =
      TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  late int _yopController = 1900;
  late int _priceController = 0;

  final WatchRepository _watchRepository = WatchRepository();
  final CsvService _csvService = CsvService();

  List<Map<String, String>> _csvData = [];

  List<String> _brands = [];
  List<String> _models = [];

  final List<String> _mvmt = ['Automatic', 'Manual Winding'];
  final List<String> _casem = [
    'Aluminium',
    'Bronze',
    'Carbon',
    'Ceramic',
    'Gold/Steel',
    'Palladium',
    'Plastic',
    'Platinum',
    'Red gold',
    'Rose gold',
    'Silver',
    'Steel',
    'Tantalum',
    'Titanium',
    'Tungsten',
    'White gold',
    'Yellow gold'
  ];
  final List<String> _bracem = [
    'Aluminium',
    'Calf skin',
    'Ceramic',
    'Cocodrile skin',
    'Gold/Steel',
    'Leather',
    'Lizard skin',
    'Ostrich skin',
    'Plastic',
    'Platinum',
    'Red gold',
    'Rose gold',
    'Rubber',
    'Satin',
    'Shark skin',
    'Silicon',
    'Silver',
    'Snake skin',
    'Steel',
    'Textile',
    'Titanium',
    'White gold',
    'Yellow gold'
  ];
  final List<String> _condition = [
    'Fair',
    'Good',
    'Incomplete',
    'New',
    'Poor',
    'Unworn',
    'Very good'
  ];
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

  // Load the database information to perform the dropowns.
  void _loadCsvData() async {
    List<Map<String, String>> data =
        await _csvService.loadCsvData('assets/database_watches.csv');
    setState(() {
      _csvData = data;
      _brands = data.map((e) => e['brand']!).toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register your watch'),
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
                      decoration: InputDecoration(
                        hintText: 'Brand *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        hintText: 'Model *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _referenceController,
                      style: TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                      decoration: InputDecoration(
                        hintText: 'Reference',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        hintText: 'Movement',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        hintText: 'Casem',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        hintText: 'Bracem',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Yop *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _yopController = int.tryParse(value) ?? 0;
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                        hintText: 'Condition *',
                        hintStyle: TextStyle(
                            color: Colors.red,
                            fontSize: isLargeScreen ? 18.0 : 14.0),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      decoration: InputDecoration(
                        hintText: 'Sex',
                        hintStyle:
                            TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
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
                              hintText: 'Price',
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
                      onPressed: _addWatch,
                      child: Text('Add your watch',
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

  // Returns the models associated to a brand according to the database
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
    String condition = _selectedCondition ?? '';
    String sex = _selectedSex ?? '';
    int price = _priceController;
    int yop = _yopController;

    if (yop > DateTime.now().year) {
      _showDialog('Invalid yop',
          'Please enter a year between zero and the actual year.');
      return;
    }

    if (price < 0) {
      _showDialog(
          'Invalid price', 'Please enter an integer and positive price.');
      return;
    }

    if (brand.trim().isEmpty ||
        model.trim().isEmpty ||
        condition.trim().isEmpty ||
        watchNickName.trim().isEmpty) {
      _showDialog('Missing fields', 'Please complete all fields.');
      return;
    }

    // Watch existe?
    bool watchExists = await _watchRepository.existWatch(watchNickName);
    if (watchExists) {
      _showDialog('Error', 'The watch already exists.');
      return;
    }

    if (brand == 'null' || model == 'null' || condition == 'null') {
      // control para no inyectar null
      _showDialog('Invalid fields',
          'The fields brand, model and condition cannot be null.');
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
