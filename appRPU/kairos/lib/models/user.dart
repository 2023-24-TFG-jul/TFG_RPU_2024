// user.dartCarga de librerias necesarias
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;   // Instanciamos la BD

// GET
Future<List> getAllUsers() async{
 List users = [];
 QuerySnapshot querySnapshot = await db.collection('users').get();    // Marca la conexion con users
 for (var user in querySnapshot.docs){                                // Trae todos las filas de users
   users.add(user.data());
 }          
 return users;
}
// ADD
Future<void> addUser(String name, String surname, 
                    String birthdate, String country, 
                    String email, String password, 
                    String bankCode) async {
  await db.collection("users").add({
   "name": name,
   "surname": surname,
   "birthdate": birthdate,
   "country": country,
   "email": email,
   "password": password,
   "bankCode": bankCode
   });
}

  // EDIT
 Future<void> updateUser(String uid, String newName) async {
   await db.collection("users").doc(uid).set({"name": newName});
 }
