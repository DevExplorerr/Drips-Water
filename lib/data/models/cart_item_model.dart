class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final String selectedSize;
  final double price;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.selectedSize,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'selectedSize': selectedSize,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      selectedSize: map['selectedSize'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }

  // Future<ProductModel> fetchProduct() async {
  //   final doc = await FirebaseFirestore.instance
  //       .collection('products')
  //       .doc(productId)
  //       .get();

  //   return ProductModel.fromFirestore(doc);
  // }
}
