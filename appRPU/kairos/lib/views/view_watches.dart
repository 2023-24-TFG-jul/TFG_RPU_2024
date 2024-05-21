import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart'; // Asegúrate de que la ruta sea correcta

class ViewWatches extends StatefulWidget {
  const ViewWatches({Key? key}) : super(key: key);

  @override
  _ViewWatchesState createState() => _ViewWatchesState();
}

class _ViewWatchesState extends State<ViewWatches> {
  final WatchRepository _watchRepository = WatchRepository();
  late Future<List<Watch>> _watchesFuture;

  @override
  void initState() {
    super.initState();
    _watchesFuture = _watchRepository.getAllWatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relojes del Usuario'),
      ),
      body: FutureBuilder<List<Watch>>(
        future: _watchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron relojes'));
          } else {
            List<Watch> watches = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Marca')),
                  DataColumn(label: Text('Modelo')),
                  DataColumn(label: Text('Referencia')),
                  DataColumn(label: Text('Movimiento')),
                  DataColumn(label: Text('Caja')),
                  DataColumn(label: Text('Brazalete')),
                  DataColumn(label: Text('Año de Producción')),
                  DataColumn(label: Text('Condición')),
                  DataColumn(label: Text('Sexo')),
                ],
                rows: watches.map((watch) {
                  return DataRow(cells: [
                    DataCell(Text(watch.brand)),
                    DataCell(Text(watch.model)),
                    DataCell(Text(watch.reference)),
                    DataCell(Text(watch.movement)),
                    DataCell(Text(watch.casem)),
                    DataCell(Text(watch.bracem)),
                    DataCell(Text(watch.yop)),
                    DataCell(Text(watch.condition)),
                    DataCell(Text(watch.sex)),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
