import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/product_model.dart';

class CartItemModel {
  final String productId;
  int quantity;

  CartItemModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'productId': productId, 'quantity': quantity};
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      quantity: map['quantity'],
    );
  }

  Future<ProductModel> fetchProduct() async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    return ProductModel.fromFirestore(doc);
  }
}
