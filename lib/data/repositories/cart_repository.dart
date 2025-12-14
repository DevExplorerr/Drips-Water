import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> cartRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  String itemKey(String productId, String size) => "${productId}_$size";

  // Add Item to Cart
  Future<void> addToCart({
    required String uid,
    required ProductModel product,
    required String size,
    required int quantity,
  }) async {
    final ref = cartRef(uid).doc(itemKey(product.id, size));
    final doc = await ref.get();

    if (doc.exists) {
      await ref.update({'quantity': FieldValue.increment(quantity)});
    } else {
      final item = CartItemModel(
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        selectedSize: size,
        quantity: quantity,
      );
      await ref.set(item.toMap());
    }
  }

  // Remove Quantity from Cart
  Future<void> decrease({
    required String uid,
    required String productId,
    required String size,
  }) async {
    final ref = cartRef(uid).doc(itemKey(productId, size));
    final doc = await ref.get();

    if (!doc.exists) return;
    final qty = doc['quantity'];

    if (qty > 1) {
      await ref.update({"quantity": qty - 1});
    } else {
      await ref.delete();
    }
  }

  // Delete Item from Cart
  Future<void> deleteItem({
    required String uid,
    required String productId,
    required String size,
  }) async {
    await cartRef(uid).doc(itemKey(productId, size)).delete();
  }

  // Clear Whole Cart
  Future<void> clearCart(String uid) async {
    final snapshot = await cartRef(uid).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
