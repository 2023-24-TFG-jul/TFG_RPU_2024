import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String idAuction;
  final String salerEmail;
  final String buyerEmail;
  final DateTime purchaseDate;
  final String auctionStatus;
  final String watchId;

  Auction({
    required this.idAuction,
    required this.salerEmail,
    required this.buyerEmail,
    required this.purchaseDate,
    required this.auctionStatus,
    required this.watchId,
  });

  factory Auction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Auction(
      idAuction: doc.id,
      salerEmail: data['salerEmail'] ?? '',
      buyerEmail: data['buyerEmail'] ?? '',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      auctionStatus: data['auctionStatus'] ?? '',
      watchId: data['watchId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salerEmail': salerEmail,
      'buyerEmail': buyerEmail,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'auctionStatus': auctionStatus,
      'watchId': watchId,
    };
  }
}

class AuctionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Auction>> getAllAuctionsWithStatusSubido() async {
    QuerySnapshot querySnapshot = await _db.collection('auctions')
    .get();
    return querySnapshot.docs.map((doc) => Auction.fromFirestore(doc)).toList();
  }

  Future<void> addAuction(Auction auction) async {
    await _db.collection('auctions').add(auction.toMap());
  }

  Future<void> updateAuction(Auction auction) async {
    await _db.collection('auctions').doc(auction.idAuction).update(auction.toMap());
  }

  Future<void> deleteAuction(String idAuction) async {
    await _db.collection('auctions').doc(idAuction).delete();
  }

  Future<void> buyWatch(String idAuction, String buyerId) async {
    await _db.collection('auctions').doc(idAuction).update({
      'buyerEmail': buyerId,
      'purchaseDate': Timestamp.now(),
    });
  }
}
