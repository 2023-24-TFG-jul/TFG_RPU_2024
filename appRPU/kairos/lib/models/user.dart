import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String surname;
  final String birthdate;
  final String country;
  final String email;

  /// User's email address. Unique
  final String password;
  final String bankCode;
  int wallet;

  /// Amount of money the user has on his account

  User({
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.country,
    required this.email,
    required this.password,
    required this.bankCode,
    required this.wallet,
  });

  /// Firestore Database -> Flutter
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
      wallet: data['wallet'] ?? 0,
    );
  }

  /// Flutter -> Firestore Database
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

  /// Returns all users
  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    QuerySnapshot querySnapshot = await _db.collection('users').get();
    for (var doc in querySnapshot.docs) {
      users.add(User.fromFirestore(doc));
    }
    return users;
  }

  /// Returns the user associated with a given id
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

  // Returns whether or not the user exists in the database
  Future<bool> checkUserExists(String email) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  /// Add a user
  Future<void> addUser(User user) async {
    await _db.collection("users").add(user.toMap());
  }

  /// Update user information
  Future<void> updateUser(
      String email,
      String newName,
      String newSurname,
      String newCountry,
      String newPassword,
      String newBankCode,
      int newWallet) async {
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
        "wallet": newWallet,
      });
    } else {
      throw Exception('User not found');
    }
  }

  // Returns money held by a user
  Future<int> getWalletByEmail(String email) async {
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

  /// Updates the user's wallet after bidding or buying the watch
  Future<void> updateUserWallet(String email, int amount) async {
    QuerySnapshot querySnapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      int currentWallet = userData['wallet'];
      int updatedWallet =
          currentWallet - amount; // currentWallet - (- amount) -> vendorEmail
      await userDoc.reference.update({'wallet': updatedWallet});
    } else {
      throw Exception('Failed to update wallet');
    }
  }
}
