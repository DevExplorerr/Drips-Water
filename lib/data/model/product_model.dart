import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String description;
  final List<String> sizes;
  final double price;
  final double rating;
  final double reviews;
  final bool isFavorite;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.sizes,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
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
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: (data['reviews'] ?? 0).toDouble(),
      isFavorite: data['isFavorite'] ?? false,
      stock: data['stock'] ?? 0,
    );
  }

  // Model to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'sizes': sizes,
      'price': price,
      'reviews': reviews,
      'rating': rating,
      'isFavorite': isFavorite,
      'stock': stock,
    };
  }

  // Map to Model
  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'],
      imageUrl: data['imageUrl'],
      category: data['category'],
      description: data['description'],
      sizes: List<String>.from(data['sizes']),
      price: (data['price']),
      reviews: data['reviews'],
      rating: data['rating'],
      isFavorite: data['isFavorite'],
      stock: data['stock'],
    );
  }


  // Copy With
  ProductModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? category,
    String? description,
    List<String>? sizes,
    double? price,
    double? reviews,
    double? rating,
    bool? isFavorite,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      description: description ?? this.description,
      sizes: sizes ?? this.sizes,
      price: price ?? this.price,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
    );
  }
}
