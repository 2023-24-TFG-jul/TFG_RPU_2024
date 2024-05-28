import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';
import 'add_watch.dart';

class ViewWatches extends StatefulWidget {
  const ViewWatches({super.key});

  @override
  State<ViewWatches> createState() => _ViewWatchesState();
}

class _ViewWatchesState extends State<ViewWatches> {
  final WatchRepository _watchRepository = WatchRepository();
  late Future<List<Watch>> _watchesFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadWatches(loginUserEmail);
    });
  }

  void _loadWatches(String loginUserEmail) {
    setState(() {
      _watchesFuture = _watchRepository.getAllWatches(loginUserEmail);
    });
  }

  void _navigateToAddWatch() async {
    final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWatch(loginUserEmail: loginUserEmail),
      ),
    );
    _loadWatches(loginUserEmail);
  }

  void _deleteWatch(String id) async {
    try {
      await _watchRepository.deleteWatch(id);
      final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadWatches(loginUserEmail);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting the watch: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your watches'),
      ),
      body: FutureBuilder<List<Watch>>(
        future: _watchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No watches found'));
          } else {
            List<Watch> watches = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Model')),
                  DataColumn(label: Text('Year of Production')),
                  DataColumn(label: Text('Condition')),
                  DataColumn(label: Text('Sex')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Sale Status')),
                  DataColumn(label: Text('Actions')),
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
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _deleteWatch(watch.id); //poner edit aqui
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteWatch(watch.id);
                            },
                          ),
                        ],
                      ),
                    )
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddWatch,
      ),
    );
  }
}