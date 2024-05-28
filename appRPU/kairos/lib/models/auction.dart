import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String idAuction;
  final String vendorEmail;
  final String buyerEmail;
  final DateTime purchaseDate;
  final String auctionStatus;
  final String watchNickName;

  Auction({
    required this.idAuction,
    required this.vendorEmail,
    required this.buyerEmail,
    required this.purchaseDate,
    required this.auctionStatus,
    required this.watchNickName,
  });

  factory Auction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Auction(
      idAuction: doc.id,
      vendorEmail: data['vendorEmail'] ?? '',
      buyerEmail: data['buyerEmail'] ?? '',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      auctionStatus: data['auctionStatus'] ?? '',
      watchNickName: data['watchNickName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorEmail': vendorEmail,
      'buyerEmail': buyerEmail,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'auctionStatus': auctionStatus,
      'watchNickName': watchNickName,
    };
  }
}

class AuctionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Auction>> getAllAuctionsWithStatusUploaded() async {
    QuerySnapshot querySnapshot = await _db.collection('auctions').get();
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

  Future<void> buyWatch(String idAuction, String buyerEmail) async {
    await _db.collection('auctions').doc(idAuction).update({
      'buyerEmail': buyerEmail,
      'purchaseDate': Timestamp.now(),
    });
  }
}
