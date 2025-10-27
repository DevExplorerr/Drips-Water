import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      "image": "assets/images/home_screen/water1.png",
      "name": "Drips Spring Water",
      "price": "\$100",
    },
    {
      "image": "assets/images/home_screen/water2.png",
      "name": "Drips Distilled Water",
      "price": "\$200",
    },
    {
      "image": "assets/images/home_screen/water3.png",
      "name": "Drips Spring Water",
      "price": "\$100",
    },
    {
      "image": "assets/images/home_screen/water4.png",
      "name": "Drips Spring Water",
      "price": "\$100",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final item = products[index];
        return ProductCard(
          productName: item['name'],
          price: item['price'],
          image: item['image'],
        );
      },
    );
  }
}
