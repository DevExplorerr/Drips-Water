// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SearchController searchController = SearchController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> allItems = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredItems = [];

  Timer? _debounce;
  bool isTyping = false;

  SearchViewModel() {
    fetchItems();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  // Fetch Items When Searching
  Future<void> fetchItems() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      allItems = snapshot.docs;
    } finally {
      notifyListeners();
    }
  }

  // Filter the item
  void onSearchChanged(String query) {
    isTyping = true;
    notifyListeners();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 400), () {
      isTyping = false;
      if (query.isEmpty) {
        filteredItems = [];
      } else {
        filteredItems = allItems
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
    filteredItems = [];
    notifyListeners();
  }
}
