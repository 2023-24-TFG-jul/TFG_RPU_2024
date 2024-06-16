import 'package:cloud_firestore/cloud_firestore.dart';

class Watch {
  final String id;
  final String
      watchNickName; // Descriptive name of the watch as desired by the user
  final String brand;
  final String model;
  final String reference; // Watch serial number
  final String movement;
  final String casem;
  final String bracem;
  final int yop; // Year of production
  final String condition;
  final String sex;
  final int price;
  final String
      saleStatus; // State of sale of the watch according to the auction

  Watch({
    required this.id,
    required this.watchNickName,
    required this.brand,
    required this.model,
    required this.reference,
    required this.movement,
    required this.casem,
    required this.bracem,
    required this.yop,
    required this.condition,
    required this.sex,
    required this.price,
    required this.saleStatus,
  });

  /// Firestore Database -> Flutter
  factory Watch.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Watch(
      id: doc.id,
      brand: data['brand'] ?? '',
      watchNickName: data['watchNickName'] ?? '',
      model: data['model'] ?? '',
      reference: data['reference'] ?? '',
      movement: data['movement'] ?? '',
      casem: data['casem'] ?? '',
      bracem: data['bracem'] ?? '',
      yop: data['yop'] ?? 1900,
      condition: data['condition'] ?? '',
      sex: data['sex'] ?? '',
      price: data['price'] ?? 0,
      saleStatus: data['saleStatus'] ?? '',
    );
  }

  /// Flutter -> Firestore Database
  Map<String, dynamic> toMap() {
    return {
      'watchNickName': watchNickName,
      'brand': brand,
      'model': model,
      'reference': reference,
      'movement': movement,
      'casem': casem,
      'bracem': bracem,
      'yop': yop,
      'condition': condition,
      'sex': sex,
      'price': price,
      'saleStatus': saleStatus,
    };
  }
}

class WatchRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns all login user watches
  Future<List<Watch>> getAllWatches(String email) async {
    List<Watch> watches = [];
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('userEmail', isEqualTo: email)
        .get();
    for (var doc in querySnapshot.docs) {
      watches.add(Watch.fromFirestore(doc));
    }
    return watches;
  }

  // Returns a watch according to its nickname
  Future<Watch> getWatchByNickname(String nickname) async {
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('watchNickName', isEqualTo: nickname)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Watch.fromFirestore(querySnapshot.docs.first);
    } else {
      throw Exception('Watch not found');
    }
  }

  /// Add a watch
  Future<void> addWatch(Watch watch, String email) async {
    Map<String, dynamic> watchData = watch.toMap();
    watchData['userEmail'] = email;
    await _db.collection("watches").add(watchData);
  }

  /// Delete a watch
  Future<void> deleteWatch(String id) async {
    await _db.collection("watches").doc(id).delete();
  }

  /// Return whether or not the watch exists to either create one or create an auction
  Future<bool> existWatch(String watchNickName) async {
    try {
      var watchQuery = await FirebaseFirestore.instance
          .collection('watches')
          .where('watchNickName', isEqualTo: watchNickName)
          .get();

      return watchQuery.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Updates the status of the watch after actions have been taken in an auction of the watch.
  Future<void> updateSaleStatusWatch(
      String watchNickName, String saleStatus) async {
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('watchNickName', isEqualTo: watchNickName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({'saleStatus': saleStatus});
    } else {
      throw Exception('Watch nickname not found: $watchNickName');
    }
  }

  // Update watch information
  Future<void> updateWatch(
      String watchNickName, String newCondition, int newPrice) async {
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('watchNickName', isEqualTo: watchNickName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs.first.id;
      await _db
          .collection("watches")
          .doc(uid)
          .update({"condition": newCondition, "price": newPrice});
    } else {
      throw Exception('Watch not found');
    }
  }
}
