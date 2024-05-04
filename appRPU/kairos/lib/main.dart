import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kairos/views/login.dart';
import 'package:kairos/views/home.dart';
import 'package:kairos/views/add_user.dart'; // Importa la clase Register
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/add_user': (context) => Register(), // Corregido aquí el nombre de la clase
      }
    );
  }
}
