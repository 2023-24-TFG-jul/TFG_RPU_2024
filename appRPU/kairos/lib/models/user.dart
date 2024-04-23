import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// GET

Future<List> getUsers() async{
  List users = [];

  CollectionReference collectionReferenceUsers = db.collection('users');    // Marca la conexion con users

  QuerySnapshot queryUsers = await collectionReferenceUsers.get();          // Trae todos las filas de users

  queryUsers.docs.forEach((user) {                                          // Recorre docs de BD y va cargando para que tengamos los users
    users.add(user.data());
  });

  return users;
}

// ADD

Future<void> addUser(String name) async {
  await db.collection("users").add({"name": name});
}