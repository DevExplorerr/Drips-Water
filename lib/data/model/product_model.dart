import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
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
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.sizes,
    required this.price,
    required this.reviews,
    required this.rating,
    required this.isFavorite,
    required this.inStock,
  });

  // Firestore to Model
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      category: data['category'],
      description: data['description'],
      sizes: List<String>.from(data['sizes']),
      price: data['price'],
      reviews: data['reviews'],
      rating: data['rating'],
      isFavorite: data['isFavorite'],
      inStock: data['inStock'],
    );
  }

  // Map to Model
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
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
      inStock: data['inStock'],
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
      'inStock': inStock,
    };
  }

  // Copy With
  Product copyWith({
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
    bool? inStock,
  }) {
    return Product(
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
      inStock: inStock ?? this.inStock,
    );
  }
}
