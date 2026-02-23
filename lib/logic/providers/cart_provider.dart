import 'dart:async';

import 'package:drips_water/core/enums/commerce_enums.dart';
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

  List<CartItemModel> _cartItems = [];
  List<CartItemModel> get cartItems => _cartItems;

  bool _isAdding = false;
  bool _isUpdatingQty = false;

  bool get isAdding => _isAdding;
  bool get isUpdatingQty => _isUpdatingQty;

  // Real-time listener
  void listenToCart() {
    if (uid == "guest" || uid.isEmpty) {
      _cartItems = [];
      notifyListeners();
      return;
    }
    _cartSub = repo.cartRef(uid).snapshots().listen((snapshot) {
      _cartItems = snapshot.docs
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

  Future<void> reorderAll(List<CartItemModel> items) async {
    if (uid.isEmpty) return;

    _isAdding = true;
    notifyListeners();

    try {
      await service.reorderItems(items);
    } finally {
      _isAdding = false;
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
    notifyListeners();

    await service.clearCart();

    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.quantity * item.selectedPrice),
    );
  }

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}

class CartResponse {
  final CartStatus status;
  final String message;

  CartResponse({required this.status, required this.message});
}
