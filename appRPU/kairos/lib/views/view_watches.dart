import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';
import 'add_watch.dart';

class ViewWatches extends StatefulWidget {
  const ViewWatches({super.key});

  @override
  _ViewWatchesState createState() => _ViewWatchesState();
}

class _ViewWatchesState extends State<ViewWatches> {
  final WatchRepository _watchRepository = WatchRepository();
  late Future<List<Watch>> _watchesFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String email = ModalRoute.of(context)!.settings.arguments as String;
      _loadWatches(email);
    });
  }

  void _loadWatches(String email) {
    setState(() {
      _watchesFuture = _watchRepository.getAllWatches(email);
    });
  }

  void _navigateToAddWatch() async {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWatch(email: email),
      ),
    );
    _loadWatches(email);
  }

  void _deleteWatch(String id) async {
    try {
      await _watchRepository.deleteWatch(id);
      final String email = ModalRoute.of(context)!.settings.arguments as String;
      _loadWatches(email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al borrar el reloj: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relojes del Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddWatch,
          ),
        ],
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
                  DataColumn(label: Text('Año de Producción')),
                  DataColumn(label: Text('Condición')),
                  DataColumn(label: Text('Sexo')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Sale Status')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: watches.map((watch) {
                  return DataRow(cells: [
                    DataCell(Text(watch.brand)),
                    DataCell(Text(watch.model)),
                    DataCell(Text(watch.yop)),
                    DataCell(Text(watch.condition)),
                    DataCell(Text(watch.sex)),
                    DataCell(Text(watch.price)),
                    DataCell(Text(watch.saleStatus)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteWatch(watch.id),
                      ),
                    ),
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
