import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      "image": "assets/images/home_screen/water1.png",
      "name": "Drips Spring Water",
      "price": "\$100",
      "description":
          "Refreshing spring water naturally filtered through mineral-rich rocks for a crisp, clean taste.",
    },
    {
      "image": "assets/images/home_screen/water2.png",
      "name": "Drips Distilled Water",
      "price": "\$50",
      "description":
          "Steam-distilled to absolute purity - perfect for labs, appliances, and medical use.",
    },
    {
      "image": "assets/images/home_screen/water3.png",
      "name": "Drips Mineral Water",
      "price": "\$50",
      "description":
          "Infused with essential minerals to keep your body hydrated and energized all day.",
    },
    {
      "image": "assets/images/home_screen/water4.png",
      "name": "Drips Premium Water",
      "price": "\$100",
      "description":
          "Ultra-pure, smooth, and naturally balanced — designed for those who value refined hydration.",
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
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final item = products[index];
        return ProductCard(
          productName: item['name'],
          price: item['price'],
          image: item['image'],
          description: item['description'],
        );
      },
    );
  }
}
