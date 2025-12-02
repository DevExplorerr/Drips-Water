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
}
