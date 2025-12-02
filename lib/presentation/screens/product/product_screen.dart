// ignore_for_file: deprecated_member_use

import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/home/cart/cart_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  final String? heroTag;
  const ProductScreen({super.key, this.heroTag, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;
  String selectedSize = "100ml";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          ProductImageSection(
            productId: widget.product.id,
            image: widget.product.imageUrl,
            heroTag: widget.heroTag ?? "",
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
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info Section
                    ProductInfoSection(
                      productName: widget.product.name,
                      price: widget.product.price,
                      description: widget.product.description,
                      rating: widget.product.rating,
                      reviews: widget.product.reviews,
                    ),

                    const SizedBox(height: 25),

                    // Options (Bottle Size + Quantity)
                    ProductOptionSection(
                      quantity: quantity,
                      selectedSize: selectedSize,
                      onQuantityChanged: (newQty) {
                        setState(() => quantity = newQty);
                      },
                      onSizeChanged: (size) {
                        setState(() => selectedSize = size);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductBottomNavbar(product: widget.product),
    );
  }
}
