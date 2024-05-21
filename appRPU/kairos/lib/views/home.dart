import 'package:flutter/material.dart';
import 'package:kairos/views/add_watch.dart';
import 'view_watches.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Ajusta el espacio alrededor del contenido
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
              const SizedBox(height: 20), // Espacio entre el texto y los botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewWatches()),
                    );
                  },
                  child: const Text('Consulte sus productos'), // Texto del botón
                ),
              ),
              const SizedBox(height: 10), // Separación entre los botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddWatch()),
                    );
                  },
                  child: const Text('Añada su reloj'),
                ),
              ),
              const SizedBox(height: 10), // Separación entre los botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Proximamente...'),
                ),
              ),
              const SizedBox(height: 10), // Separación entre los botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Proximamente...R'),
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
