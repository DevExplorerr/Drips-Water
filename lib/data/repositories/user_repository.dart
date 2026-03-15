import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/card_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setUserCard(String uid, CardModel card) async {
    await _firestore.collection('users').doc(uid).update({
      'savedCard': card.toMap(),
    });
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }
}
