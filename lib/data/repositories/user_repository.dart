import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/address_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> fetchUserName(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return null;
    return snapshot.data()?['name'] ?? 'Guest';
  }

  Future<void> setUserAddress(String uid, AddressModel address) async {
    await _firestore.collection('users').doc(uid).update({
      'shippingAddress': address.toMap(),
    });
  }

  Future<AddressModel?> fetchUserAddress(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists && snapshot.data()!.containsKey('shippingAddress')) {
      final data = snapshot.data()!['shippingAddress'];
      if (data != null) {
        return AddressModel.fromMap(data);
      }
    }
    return null;
  }
}
