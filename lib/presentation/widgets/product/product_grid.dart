import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;
    return SingleChildScrollView(
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
          final product = products[index];
          return ProductCard(
            productName: product['name'],
            price: product['price'],
            image: product['image'],
            description: product['description'],
            rating: product['rating'],
            reviews: product['reviews'],
          );
        },
      ),
    );
  }
}
