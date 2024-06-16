import 'package:flutter/material.dart';
import 'package:kairos/models/watch.dart';
import 'package:kairos/views/update_watch.dart';
import 'add_watch.dart';

class ViewWatches extends StatefulWidget {
  const ViewWatches({super.key});

  @override
  State<ViewWatches> createState() => _ViewWatchesState();
}

class _ViewWatchesState extends State<ViewWatches> {
  final WatchRepository _watchRepository = WatchRepository();
  late Future<List<Watch>> _watchesFuture;
  late String loginUserEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;
      _loadWatches(loginUserEmail);
    });
  }

  void _loadWatches(String email) {
    setState(() {
      _watchesFuture = _watchRepository.getAllWatches(email);
    });
  }

  void _navigateToAddWatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWatch(loginUserEmail: loginUserEmail),
      ),
    );
    _loadWatches(loginUserEmail);
  }

  void _navigateToUpdateWatch(String watchNickName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateWatch(watchNickName: watchNickName),
      ),
    );
    _loadWatches(loginUserEmail);
  }

  void _deleteWatch(String id) async {
    try {
      await _watchRepository.deleteWatch(id);
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
        title: const Text('Your Watches'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/kairos_wallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Watch>>(
          future: _watchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No watches found.'));
            } else {
              List<Watch> watches = snapshot.data!;
              return ListView.builder(
                itemCount: watches.length,
                itemBuilder: (context, index) {
                  Watch watch = watches[index];
                  bool isFinished = (watch.saleStatus == 'Purchased' ||
                      watch.saleStatus == 'At auction');

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(watch.watchNickName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRichText('Brand: ', watch.brand),
                          _buildRichText('Model: ', watch.model),
                          _buildRichText(
                              'Year of Production: ', watch.yop.toString()),
                          _buildRichText('Condition: ', watch.condition),
                          _buildRichText('Sex: ', watch.sex),
                          _buildRichText('Price: ', watch.price.toString()),
                          _buildRichText('Sale Status: ', watch.saleStatus),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: isFinished
                                ? null
                                : () =>
                                    _navigateToUpdateWatch(watch.watchNickName),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: isFinished
                                ? null
                                : () => _deleteWatch(watch.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWatch,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
