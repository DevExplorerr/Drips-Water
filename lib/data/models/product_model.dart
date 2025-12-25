import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String description;
  final List<String> sizes;
  final Map<String, int> pricePerSize;
  final double price;
  final double rating;
  final int reviews;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.sizes,
    required this.pricePerSize,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.stock,
  });

  // Firestore to Model
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      pricePerSize: Map<String, int>.from(data['pricePerSize'] ?? []),
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'],
      stock: data['stock'] ?? 0,
    );
  }
}
