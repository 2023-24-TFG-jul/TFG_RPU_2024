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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final String loginUserEmail = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => Home(loginUserEmail: loginUserEmail),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const Login());
          case '/add_user':
            return MaterialPageRoute(builder: (context) => const Register());
          case '/add_watch':
            final String loginUserEmail = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => AddWatch(loginUserEmail: loginUserEmail),
            );
          case '/view_watches':
            return MaterialPageRoute(builder: (context) => const ViewWatches());
          default:
            return null;
        }
      },
    );
  }
}
