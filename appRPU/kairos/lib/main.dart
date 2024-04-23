import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kairos/views/home.dart';
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
    return const MaterialApp(
      title: 'Home',
      home: Home(),
      // Marcar rutas aqui
    );
  }
}

// class UserListScreen extends StatefulWidget {
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   List users = [];

//   @override
//   void initState() {
//     super.initState();
//     getUsersFromFirestore();
//   }

//   Future<void> getUsersFromFirestore() async {
//     List fetchedUsers = await getUsers();
//     setState(() {
//       users = fetchedUsers;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(users[index]['name'])
//           );
//         },
//       ),
//     );
//   }
// }