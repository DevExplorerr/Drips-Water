import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/logic/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductGridViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> products = [];
  bool isLoading = false;
  String selectedCategory = "All";

  String get categorySelected => selectedCategory;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    products = await _service.getProductsByCategory(selectedCategory);

    isLoading = false;
    notifyListeners();
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
    loadProducts();
  }
}
