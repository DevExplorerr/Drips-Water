import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = .instance;

  Stream<QuerySnapshot> fetchAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }
}
