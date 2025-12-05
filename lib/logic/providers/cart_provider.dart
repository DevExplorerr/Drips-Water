import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/data/services/cart_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository repo;
  final CartService service;
  final String uid;

  CartProvider({required this.repo, required this.uid, required this.service}) {
    listenToCart();
  }

  List<CartItemModel> cartItems = [];
  bool get isAdding => service.isProcessing;

  // Real-time listener
  void listenToCart() {
    repo.cartRef(uid).snapshots().listen((snapshot) {
      cartItems = snapshot.docs
          .map((e) => CartItemModel.fromMap(e.data()))
          .toList();
      notifyListeners();
    });
  }

  Future<String> addToCart(
    ProductModel product,
    String size,
    int quantity,
  ) async {
    notifyListeners();
    final msg = await service.addToCart(
      product: product,
      size: size,
      quantity: quantity,
    );
    notifyListeners();

    return msg;
  }

  Future<void> decrease(String productId, String size) async {
    await service.decrease(productId, size);
  }

  Future<void> deleteItem(String productId, String size) async {
    await service.deleteItem(productId, size);
  }

  Future<void> clear() async => await service.clearCart();

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
}
