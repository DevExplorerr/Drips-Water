import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/data/repositories/order_repository.dart';

class OrderService {
  final OrderRepository _orderRepository = OrderRepository();

  Future<void> placeOrder(OrderModel order) async {
    try {
      await _orderRepository.createOrder(order);
    } catch (e) {
      throw Exception("Failed to place order");
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _orderRepository.cancelOrder(orderId);
    } catch (e) {
      throw Exception("Failed to cancel order: $e");
    }
  }
}
