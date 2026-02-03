import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/data/services/order_service.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void _setLoading(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  Future<String?> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required AddressModel address,
    required String paymentMethod,
    required String deliveryOption,
    required DateTime? scheduledTime,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double totalAmount,
  }) async {
    _setLoading(true);

    try {
      final String orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";

      final newOrder = OrderModel(
        id: orderId,
        userId: userId,
        items: items,
        address: address,
        paymentMethod: paymentMethod,
        deliveryOption: deliveryOption,
        scheduledTime: scheduledTime,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        totalAmount: totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _service.placeOrder(newOrder);
      return orderId;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
