import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firebase.collection('orders').doc(order.id).set(order.toMap());
  }

  Stream<List<OrderModel>> getUserOrders(
    String userId, {
    String? statusFilter,
  }) {
    Query query = _firebase
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (statusFilter != null && statusFilter != 'All') {
      query = query.where('status', isEqualTo: statusFilter.toLowerCase());
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> cancelOrder(String orderId) async {
    await _firebase.collection('orders').doc(orderId).update({
      'status': 'cancelled',
      'updateAt': FieldValue.serverTimestamp(),
    });
  }
}
