import 'package:cloud_firestore/cloud_firestore.dart';

class Watch {
  final String id;
  final String watchNickName;
  final String brand;
  final String model;
  final String reference;
  final String movement;
  final String casem;
  final String bracem;
  final String yop;
  final String condition;
  final String sex;
  final String price;
  final String saleStatus;

  Watch({
    required this.id,
    required this.watchNickName, // facilidad para el usuario a la hora de crear una subasta
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
      yop: data['yop'] ?? '',
      condition: data['condition'] ?? '',
      sex: data['sex'] ?? '',
      price: data['price'] ?? '',
      saleStatus: data['saleStatus'] ?? '',
    );
  }

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

  Future<List<Watch>> getAllWatches(String email) async {
    List<Watch> watches = [];
    QuerySnapshot querySnapshot = await _db.collection('watches')
        .where('userEmail', isEqualTo: email)
        .get();
    for (var doc in querySnapshot.docs) {
      watches.add(Watch.fromFirestore(doc));
    }
    return watches;
  }

  // watch exist?
  Future<bool> checkWatchExists(String nickname) async {
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('watchNickName', isEqualTo: nickname)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addWatch(Watch watch, String email) async {
    Map<String, dynamic> watchData = watch.toMap();
    watchData['userEmail'] = email;
    await _db.collection("watches").add(watchData);
  }

  Future<void> deleteWatch(String id) async {
    await _db.collection("watches").doc(id).delete();
  }

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

  Future<void> updateSaleStatusWatch(String watchNickName, String saleStatus) async {
    QuerySnapshot querySnapshot = await _db.collection('watches')
    .where('watchNickName', isEqualTo: watchNickName)
    .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({'saleStatus': saleStatus});
    } else {
      throw Exception('Watch nickname not found: $watchNickName');
    }
  }

  // GET WATCH BY NICKNAME
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

  // UPDATE
  Future<void> updateWatch(String watchNickName,
                          String newCondition, 
                          String newPrice) async {
    QuerySnapshot querySnapshot = await _db
        .collection('watches')
        .where('watchNickName', isEqualTo: watchNickName)
        .limit(1)
        .get();
        
    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs.first.id;
      await _db.collection("watches").doc(uid).update({
        "condition": newCondition,
        "price": newPrice
      });
    } else {
      throw Exception('Watch not found');
    }
  }

}
