import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String surname;
  final String birthdate;
  final String country;
  final String email;
  final String password;
  final String bankCode;

  User({
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.country,
    required this.email,
    required this.password,
    required this.bankCode,
  });

  // doc de Firestore en objeto User
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      birthdate: data['birthdate'] ?? '',
      country: data['country'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      bankCode: data['bankCode'] ?? '',
    );
  }

  // objeto User en doc para agregar a Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'birthdate': birthdate,
      'country': country,
      'email': email,
      'password': password,
      'bankCode': bankCode,
    };
  }
}

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // GET
  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    QuerySnapshot querySnapshot = await _db.collection('users').get();
    for (var doc in querySnapshot.docs) {
      users.add(User.fromFirestore(doc));
    }
    return users;
  }

  // user exist?
  Future<bool> checkUserExists(String email) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // ADD
  Future<void> addUser(User user) async {
    await _db.collection("users").add(user.toMap());
  }

  // UPDATE
  Future<void> updateUser(String uid, String newName) async {
    await _db.collection("users").doc(uid).update({"name": newName});
  }
}