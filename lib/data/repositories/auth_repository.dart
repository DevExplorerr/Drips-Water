import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String userName,
    required String email,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "uid": uid,
      "name": userName,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
