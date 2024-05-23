import 'package:flutter/material.dart';
import 'view_watches.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome, $email',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewWatches(),
                        settings: RouteSettings(arguments: email),
                      ),
                    );
                  },
                  child: const Text('Consulte sus productos'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Relojes en venta'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Proximamente...'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Proximamente...'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
        icon: const Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
