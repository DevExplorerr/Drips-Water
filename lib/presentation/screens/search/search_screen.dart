import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _searchController = SearchController();
  final searchRef = FirebaseFirestore.instance.collection('products');

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allItems = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredItems = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchSearchItems();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  // Fetch Items When Searching
  Future<void> _fetchSearchItems() async {
    try {
      final snapshot = await searchRef.get();
      if (!mounted) return;
      setState(() {
        _allItems = snapshot.docs;
        _filteredItems = [];
      });
    } catch (e) {
      if (mounted) {
        showFloatingSnackBar(
          context,
          message: "Error Fetching Products: $e",
          backgroundColor: AppColors.error,
        );
      }
    }
  }

  // Filter the item
  void _filterList(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      if (query.isEmpty) {
        setState(() => _filteredItems = []);
        return;
      }

      setState(() {
        _filteredItems = _allItems
            .where(
              (doc) => doc.data()['name'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SearchBar(
              controller: _searchController,
              hintText: "Search something...",
              autoFocus: true,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              leading: const Icon(Icons.search, color: AppColors.primary),
              trailing: <Widget>[
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _filterList('');
                  },
                  icon: const Icon(Icons.clear, color: AppColors.primary),
                ),
              ],
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onChanged: _filterList,
            ),
          ),

          Expanded(
            child: _searchController.text.isEmpty
                ? Center(
                    child: Text(
                      "Start typing to search products",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : _filteredItems.isEmpty
                ? Center(
                    child: Text(
                      "No Products Found",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: GridView.builder(
                      itemCount: _filteredItems.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 20,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final product = _filteredItems[index];
                        final data = product.data();
                        data['id'] = product.id;
                        return ProductCard(data: data);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
