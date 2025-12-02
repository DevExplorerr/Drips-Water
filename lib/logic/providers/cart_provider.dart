import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/product_model.dart';
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

  Future<ProductModel> getProduct(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    return ProductModel.fromFirestore(doc);
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

  double get totalPrice =>
      cartItems.fold(0, (double sum, item) => sum + item.quantity);
}
