import 'dart:async';

import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/data/services/cart_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository repo;
  final CartService service;
  final String uid;

  StreamSubscription? _cartSub;

  CartProvider({required this.repo, required this.uid, required this.service}) {
    listenToCart();
  }

  List<CartItemModel> cartItems = [];

  bool _isAdding = false;
  bool _isUpdatingQty = false;
  bool _isClearingCart = false;

  bool get isAdding => _isAdding;
  bool get isUpdatingQty => _isUpdatingQty;
  bool get isClearingCart => _isClearingCart;

  // Real-time listener
  void listenToCart() {
    if (uid.isEmpty) {
      cartItems = [];
      notifyListeners();
      return;
    }
    _cartSub = repo.cartRef(uid).snapshots().listen((snapshot) {
      cartItems = snapshot.docs
          .map((e) => CartItemModel.fromMap(e.data()))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _cartSub?.cancel();
    super.dispose();
  }

  Future<CartResponse> addToCart(
    ProductModel product,
    String size,
    int quantity,
  ) async {
    if (uid.isEmpty) {
      return CartResponse(
        status: CartStatus.guestBlocked,
        message: "Please sign in to add items to cart",
      );
    }

    try {
      _isAdding = true;
      _isUpdatingQty = true;
      notifyListeners();

      final msg = await service.addToCart(
        product: product,
        size: size,
        quantity: quantity,
      );
      return CartResponse(status: CartStatus.success, message: msg);
    } catch (e) {
      return CartResponse(
        status: CartStatus.error,
        message: "Something went wrong. Try again",
      );
    } finally {
      _isAdding = false;
      _isUpdatingQty = false;
      notifyListeners();
    }
  }

  Future<void> decrease(String productId, String size) async {
    if (_isUpdatingQty) return;

    _isUpdatingQty = true;
    notifyListeners();

    await service.decrease(productId, size);

    _isUpdatingQty = false;
    notifyListeners();
  }

  Future<void> deleteItem(String productId, String size) async {
    await service.deleteItem(productId, size);
  }

  Future<void> clearCart() async {
    _isClearingCart = true;
    notifyListeners();

    await service.clearCart();

    cartItems.clear();
    _isClearingCart = false;
    notifyListeners();
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
}

enum CartStatus { success, guestBlocked, error }

class CartResponse {
  final CartStatus status;
  final String message;

  CartResponse({required this.status, required this.message});
}
