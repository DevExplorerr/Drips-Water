// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/logic/services/search_service.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchService _searchService;

  SearchViewModel(this._searchService) {
    loadProducts();
  }

  final TextEditingController searchController = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> allProducts = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredProducts = [];

  Timer? _debounce;
  bool isTyping = false;
  bool isLoading = false;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    allProducts = await _searchService.fetchProducts();

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  // Filter the item
  void onSearchChanged(String query) {
    isTyping = true;
    notifyListeners();

    _debounce?.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 400), () {
      isTyping = false;

      if (query.isEmpty) {
        filteredProducts = [];
      } else {
        filteredProducts = allProducts
            .where(
              (doc) => doc.data()['name'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }

      notifyListeners();
    });
  }

  // Clear input
  void clearSearch() {
    searchController.clear();
    filteredProducts = [];
    notifyListeners();
  }
}
