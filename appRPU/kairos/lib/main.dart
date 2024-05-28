import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kairos/views/add_watch.dart';
import 'package:kairos/views/login.dart';
import 'package:kairos/views/home.dart';
import 'package:kairos/views/add_user.dart';
import 'package:kairos/views/view_watches.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/add_user': (context) => const Register(),
        '/add_watch': (context) => const AddWatch(loginUserEmail: '',),
        '/view_watches': (context) => const ViewWatches(),
      }
    );
  }
}
