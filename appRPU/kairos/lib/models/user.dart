import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String surname;
  final String birthdate;   // no editable
  final String country;
  final String email;       // no editable
  final String password;
  final String bankCode;
  final String wallet;

  User({
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.country,
    required this.email,
    required this.password,
    required this.bankCode,
    required this.wallet
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
      wallet: data['wallet'] ?? '',
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
      'wallet': wallet,
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
  Future<void> updateUser(String email, 
                          String newName,
                          String newSurname,
                          String newCountry,
                          String newPassword,
                          String newBankCode,
                          String newWallet) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
        
    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs.first.id;
      await _db.collection("users").doc(uid).update({
        "name": newName,
        "surname": newSurname,
        "country": newCountry,
        "password": newPassword,
        "bankCode": newBankCode,
        "wallet": newWallet
      });
    } else {
      throw Exception('User not found');
    }
  }

  // GET USER BY EMAIL
  Future<User> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
        
    if (querySnapshot.docs.isNotEmpty) {
      return User.fromFirestore(querySnapshot.docs.first);
    } else {
      throw Exception('User not found');
    }
  }

  
  // GET WALLET BY EMAIL
  Future<String> getWalletByEmail(String email) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
        
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['wallet'];
    } else {
      throw Exception('User not found');
    }
  }
}
