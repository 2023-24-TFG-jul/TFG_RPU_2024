import 'package:flutter/material.dart';
import 'add_user.dart';

class Home extends StatefulWidget {
  const Home ({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
              child: const Text('Registrarse'), // Texto del botón
            ),
            ElevatedButton(
              onPressed: () {
                // COSASSS
              },
              child: const Text('Segundo Botón'),
            ),
            ElevatedButton(
              onPressed: () {
                // COSASSS
              },
              child: const Text('Tercer Botón'),
            ),
            ElevatedButton(
              onPressed: () {
                // COSASSS
              },
              child: const Text('Cuarto Botón'),
            ),
          ],
        ),
      ),
    );
  }
}
