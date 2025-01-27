import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String idAuction;
  final String vendorEmail;
  final String watchNickName;
  final DateTime limitDate;
  final int minimumValue;
  final int maximumValue;
  String buyerEmail;
  String auctionStatus;
  int actualValue;

  Auction({
    required this.idAuction,
    required this.vendorEmail,
    required this.watchNickName,
    required this.limitDate,
    required this.minimumValue,
    required this.maximumValue,
    required this.buyerEmail,
    required this.auctionStatus,
    required this.actualValue,
  });

  /// Firestore Database -> Flutter
  factory Auction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Auction(
        idAuction: doc.id,
        vendorEmail: data['vendorEmail'] ?? '',
        buyerEmail: data['buyerEmail'] ?? '',
        limitDate: (data['limitDate'] as Timestamp).toDate(),
        auctionStatus: data['auctionStatus'] ?? '',
        watchNickName: data['watchNickName'] ?? '',
        minimumValue: data['minimumValue'] ?? 0,
        actualValue: data['actualValue'] ?? 0,
        maximumValue: data['maximumValue'] ?? 0);
  }

  /// Flutter -> Firestore Database
  Map<String, dynamic> toMap() {
    return {
      'vendorEmail': vendorEmail,
      'buyerEmail': buyerEmail,
      'limitDate': limitDate,
      'auctionStatus': auctionStatus,
      'watchNickName': watchNickName,
      'minimumValue': minimumValue,
      'actualValue': actualValue,
      'maximumValue': maximumValue
    };
  }
}

class AuctionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns all auctions
  Future<List<Auction>> getAllAuctions() async {
    QuerySnapshot querySnapshot = await _db.collection('auctions').get();
    return querySnapshot.docs.map((doc) => Auction.fromFirestore(doc)).toList();
  }

  /// Returns the auction according to the auction id
  Future<Auction> getAuctionById(String id) async {
    DocumentSnapshot doc = await _db.collection('auctions').doc(id).get();
    if (doc.exists) {
      return Auction.fromFirestore(doc);
    } else {
      throw Exception('Auction not found');
    }
  }

  /// Add an auction
  Future<void> addAuction(Auction auction) async {
    await _db.collection('auctions').add(auction.toMap());
  }

  /// Delete an auction
  Future<void> deleteAuction(String idAuction) async {
    await _db.collection('auctions').doc(idAuction).delete();
  }

  /// Function for direct purchase. The current value becomes the direct purchase value
  Future<void> buyWatch(
      String idAuction, String buyerEmail, int maximumValue) async {
    await _db
        .collection('auctions')
        .doc(idAuction)
        .update({'buyerEmail': buyerEmail, 'actualValue': maximumValue});
  }

  /// Function to control the changes in the auction status depending on the action taken
  Future<void> updateAuctionStatus(
      String watchNickName, String auctionStatus) async {
    QuerySnapshot querySnapshot = await _db
        .collection('auctions')
        .where('watchNickName', isEqualTo: watchNickName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({'auctionStatus': auctionStatus});
    } else {
      throw Exception(
          'Auction not found with the following data: $watchNickName');
    }
  }

  /// Function to apply the auction change when applying and/or purchasing.
  Future<void> updateBid(
      String watchNickName, int newBid, String newBuyer) async {
    QuerySnapshot querySnapshot = await _db
        .collection('auctions')
        .where('watchNickName', isEqualTo: watchNickName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentReference = querySnapshot.docs.first.reference;
      await documentReference
          .update({'actualValue': newBid, 'buyerEmail': newBuyer});
    } else {
      throw Exception(
          'Auction not found with the following data: $watchNickName');
    }
  }
}
