import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductGridViewModel extends ChangeNotifier {
  final ProductRepository _repo = ProductRepository();

  List<ProductModel> products = [];
  bool isLoading = false;
  String selectedCategory = "All";

  String get categorySelected => selectedCategory;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    products = await _repo.fetchProductsByCategory(selectedCategory);

    isLoading = false;
    notifyListeners();
  }

  void changeCategory(String category) {
    if (category == selectedCategory) return;

    selectedCategory = category;
    loadProducts();
  }
}
