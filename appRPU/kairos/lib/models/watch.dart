import 'package:cloud_firestore/cloud_firestore.dart';

class Watch {
  final String brand;
  final String model;
  final String reference;
  final String movement;
  final String casem;
  final String bracem;
  final String yop;
  final String condition;
  final String sex;

  Watch({
    required this.brand,
    required this.model,
    required this.reference,
    required this.movement,
    required this.casem,
    required this.bracem,
    required this.yop,
    required this.condition,
    required this.sex,
  });

  // doc de Firestore en objeto Watch
  factory Watch.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Watch(
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      reference: data['reference'] ?? '',
      movement: data['movement'] ?? '',
      casem: data['casem'] ?? '',
      bracem: data['bracem'] ?? '',
      yop: data['yop'] ?? '',
      condition: data['condition'] ?? '',
      sex: data['sex'] ?? '',
    );
  }

  // objeto Watch en doc para agregar a Firestore
  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'reference': reference,
      'movement': movement,
      'casem': casem,
      'bracem': bracem,
      'yop': yop,
      'condition': condition,
      'sex': sex,
    };
  }
}

class WatchRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // GET
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

  // ADD
  Future<void> addWatch(Watch watch) async {
    await _db.collection("watches").add(watch.toMap());
  }

  // UPDATE -> repasar bien esto
  Future<void> updateWatch(String uid, String newName) async {
    await _db.collection("watches").doc(uid).update({"brand": newName});
  }
}
