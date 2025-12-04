import 'package:drips_water/data/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository repo;
  final String uid;

  CartProvider(this.repo, this.uid) {
    listenToCart();
  }

  List<CartItemModel> cartItems = [];

  // Real-time listener
  void listenToCart() {
    repo.cartRef(uid).snapshots().listen((snapshot) {
      cartItems = snapshot.docs
          .map((e) => CartItemModel.fromMap(e.data()))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addToCart(ProductModel product, String size, int quantity) async {
    await repo.addToCart(uid: uid, product: product, size: size, quantity: quantity);
  }

  Future<void> decrease(String productId, String size) async {
    await repo.decrease(uid: uid, productId: productId, size: size);
  }

  Future<void> deleteItem(String productId, String size) async {
    await repo.deleteItem(uid: uid, productId: productId, size: size);
  }

  Future<void> clear() async => await repo.clearCart(uid);

  double get totalPrice {
    return cartItems.fold(
      0,
      (double sum, item) => sum + (item.quantity * item.price),
    );
  }

  int get totalItems =>
      cartItems.fold(0, (int sum, item) => sum + item.quantity);
}



  // Future<ProductModel> getProduct(String productId) async {
  //   final doc = await FirebaseFirestore.instance
  //       .collection('products')
  //       .doc(productId)
  //       .get();

  //   return ProductModel.fromFirestore(doc);
  // }