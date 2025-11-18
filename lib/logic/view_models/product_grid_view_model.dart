import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductGridViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String selectedCategory = "All";

  List<QueryDocumentSnapshot> products = [];

  Future<void> loadProducts(String category) async {
    isLoading = true;
    notifyListeners();

    selectedCategory = category;

    Query query = _firestore.collection('products');

    if (category != "All") {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    products = snapshot.docs;

    isLoading = false;
    notifyListeners();
  }
}
