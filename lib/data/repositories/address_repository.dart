import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for real-time updates in AddressManagementScreen
  Stream<List<AddressModel>> getAddressesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddressModel.fromMap(doc.data(), docId: doc.id))
              .toList(),
        );
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> updateAddress(
    String uid,
    String addressId,
    AddressModel address,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }
}
