import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String idAuction;
  final String vendorEmail;
  String buyerEmail;
  final String limitDate;
  final String auctionStatus;
  final String watchNickName;
  final String minimumValue;
  String actualValue;
  final String maximumValue;

  Auction({
    required this.idAuction,
    required this.vendorEmail,
    required this.buyerEmail,
    required this.limitDate,
    required this.auctionStatus,
    required this.watchNickName,
    required this.minimumValue,
    required this.actualValue,
    required this.maximumValue,
  });

  factory Auction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Auction(
      idAuction: doc.id,
      vendorEmail: data['vendorEmail'] ?? '',
      buyerEmail: data['buyerEmail'] ?? '',
      limitDate: data['limitDate'] ?? '',
      auctionStatus: data['auctionStatus'] ?? '',
      watchNickName: data['watchNickName'] ?? '',
      minimumValue: data['minimumValue'] ?? '',
      actualValue: data['actualValue'] ?? '',
      maximumValue: data['maximumValue'] ?? ''
    );
  }

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

  void updateBid(String newBid) {
    actualValue = newBid;
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

  Future<void> buyWatch(String idAuction, String buyerEmail, String maximumValue) async {
    await _db.collection('auctions').doc(idAuction).update({
      'buyerEmail': buyerEmail,
      'actualValue': maximumValue //compras directo, pues el valora actual es el
    });
  }

  Future<Auction> getAuctionById(String id) async {
    DocumentSnapshot doc = await _db.collection('auctions').doc(id).get();
    if (doc.exists) {
      return Auction.fromFirestore(doc);
    } else {
      throw Exception('Auction not found');
    }
  }

  Future<void> updateAuctionStatus(String watchNickName, String auctionStatus) async {
    QuerySnapshot querySnapshot = await _db.collection('auctions')
      .where('watchNickName', isEqualTo: watchNickName)
      .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({'auctionStatus': auctionStatus});
    } else {
      throw Exception('Auction not found with the following data: $watchNickName');
    }
  }
}
