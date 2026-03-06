import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/card_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> fetchUserName(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return null;
    return snapshot.data()?['name'] ?? 'Guest';
  }

  Future<void> setUserCard(String uid, CardModel card) async {
    await _firestore.collection('users').doc(uid).update({
      'savedCard': card.toMap(),
    });
  }

  Future<CardModel?> fetchUserCard(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists && snapshot.data()!.containsKey('savedCard')) {
      final data = snapshot.data()!['savedCard'];
      if (data != null) {
        return CardModel.fromMap(data);
      }
    }
    return null;
  }
}
