import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firebase.collection('orders').doc(order.id).set(order.toMap());
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firebase
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
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
