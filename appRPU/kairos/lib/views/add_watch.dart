import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';

class AddWatch extends StatefulWidget {
  const AddWatch({
    super.key,
  });

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {
  
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _movementController = TextEditingController();
  final TextEditingController _casemController = TextEditingController();
  final TextEditingController _bracemController = TextEditingController();
  final TextEditingController _yopController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();

  final WatchRepository _watchRepository = WatchRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Reloj'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              obscureText: true,
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
              obscureText: true,
            ),
            TextField(
              controller: _sexController,
              decoration: const InputDecoration(labelText: 'Sex'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addWatch();
              },
              child: const Text('Añadir reloj'),
            ),
          ],
        ),
      ),
    );
  }

  void _addWatch() async {
    String brand = _brandController.text;
    String model = _modelController.text;
    String reference = _referenceController.text;
    String movement = _movementController.text;
    String casem = _casemController.text;
    String bracem = _bracemController.text;
    String yop = _yopController.text;
    String condition = _conditionController.text;
    String sex = _sexController.text;

    if (brand.isEmpty ||
        model.isEmpty ||
        reference.isEmpty ||
        movement.isEmpty ||
        casem.isEmpty ||
        bracem.isEmpty ||
        yop.isEmpty ||
        condition.isEmpty ||
        sex.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Campos faltantes'),
            content: const Text('Por favor complete todos los campos.'),
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
      await _watchRepository.addWatch(Watch(
        brand: brand,
        model: model,
        reference: reference,
        movement: movement,
        casem: casem,
        bracem: bracem,
        yop: yop,
        condition: condition,
        sex: sex,
      ));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reloj regitrado correctamente'),
            content: const Text('Reloj regitrado correctamente'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error al registrar el reloj: $e'),
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
