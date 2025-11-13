import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatefulWidget {
  final String selectedCategory;
  const ProductGrid({super.key, required this.selectedCategory});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<QuerySnapshot> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(covariant ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    final productsRef = FirebaseFirestore.instance.collection('products');
    Query query = productsRef;

    if (widget.selectedCategory != 'All') {
      query = query.where('category', isEqualTo: widget.selectedCategory);
    }

    setState(() {
      _productsFuture = query.get();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;

    return FutureBuilder<QuerySnapshot>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductCardLoadingIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No products found.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final products = snapshot.data!.docs;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 40),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final productDoc = products[index];
              final data = productDoc.data() as Map<String, dynamic>;
              data['id'] = productDoc.id;
              return ProductCard(data: data);
            },
          ),
        );
      },
    );
  }
}
