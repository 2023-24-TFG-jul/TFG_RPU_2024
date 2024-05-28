import 'package:flutter/material.dart';

class ViewPriceWatch extends StatefulWidget {

  const ViewPriceWatch({super.key});

  @override
  State<ViewPriceWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<ViewPriceWatch> {
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
            // ElevatedButton(
            //   onPressed: _addWatch,
            //   child: const Text('Añadir reloj'),
            // ),
          ],
        ),
      ),
    );
  }

  
}
