class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final String selectedSize;
  final int selectedPrice;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.selectedSize,
    required this.selectedPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'selectedSize': selectedSize,
      'selectedPrice': selectedPrice,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      selectedSize: map['selectedSize'],
      selectedPrice: map['selectedPrice'],
      quantity: (map['quantity'] ?? 1),
    );
  }
}
