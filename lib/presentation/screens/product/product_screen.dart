// ignore_for_file: deprecated_member_use

import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/home/cart/cart_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;
  final String? heroTag;
  const ProductScreen({super.key, this.heroTag, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          // Product Image Section
          ProductImageSection(
            productId: product.id,
            image: product.imageUrl,
            heroTag: heroTag ?? "",
            onBack: () => Navigator.pop(context),
            onNavigate: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),

          // Product Info
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const .only(left: 15, right: 15, top: 20, bottom: 50),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Product Info Section
                    ProductInfoSection(
                      productName: product.name,
                      description: product.description,
                      price: product.price,
                      rating: product.rating,
                      reviews: product.reviews,
                      stock: product.stock,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductBottomNavbar(product: product),
    );
  }
}
