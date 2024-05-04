import 'package:flutter/material.dart';
import 'add_user.dart'; // Importa la página de registro

class Home extends StatefulWidget {
  const Home ({
    Key? key,
  }) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text('Registrarse'), // Texto del botón
            ),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la navegación para el segundo botón
              },
              child: Text('Segundo Botón'),
            ),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la navegación para el tercer botón
              },
              child: Text('Tercer Botón'),
            ),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la navegación para el cuarto botón
              },
              child: Text('Cuarto Botón'),
            ),
          ],
        ),
      ),
    );
  }
}
