import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _repo = CartRepository();
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  List<CartItemModel> cartItems = [];

  // Real-time listener
  void listenToCart() {
    CartRepository().getCartRef(_uid).snapshots().listen((snapshot) {
      cartItems = snapshot.docs
          .map((e) => CartItemModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addToCart(String productId) async {
    await _repo.addItem(_uid, CartItemModel(productId: productId, quantity: 1));
  }

  Future<void> removeFromCart(String productId) async {
    await _repo.removeItem(_uid, productId);
  }

  Future<void> deleteProduct(String productId) async {
    await _repo.deleteProduct(_uid, productId);
  }

  Future<void> clearCart() async {
    await _repo.clearCart(_uid);
  }

  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);
}
