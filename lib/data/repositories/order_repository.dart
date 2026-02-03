import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firebase.collection('orders').doc(order.id).set(order.toMap());
  }
}
