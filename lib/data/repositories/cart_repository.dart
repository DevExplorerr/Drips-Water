import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference getCartRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('cart');

  // Add Item to Cart
  Future<void> addItem(String uid, CartItemModel item) async {
    final ref = getCartRef(uid).doc(item.productId);

    final doc = await ref.get();
    if (doc.exists) {
      await ref.update({
        'quantity': FieldValue.increment(1),
      });
    } else {
      await ref.set(item.toMap());
    }
  }

  // Remove Quantity from Cart
  Future<void> removeItem(String uid, String productId) async {
    final ref = getCartRef(uid).doc(productId);

    final doc = await ref.get();
    if (!doc.exists) return;

    final currentQty = doc['quantity'] as int;

    if (currentQty > 1) {
      await ref.update({'quantity': currentQty - 1});
    } else {
      await ref.delete();
    }
  }

  // Delete Item from Cart
  Future<void> deleteProduct(String uid, String productId) async {
    await getCartRef(uid).doc(productId).delete();
  }

  // Clear Whole Cart 
  Future<void> clearCart(String uid) async {
    final snapshot = await getCartRef(uid).get();
    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }
}
