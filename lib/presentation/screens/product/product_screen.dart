// ignore_for_file: deprecated_member_use

import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String image;
  final int price;
  final String description;
  final double rating;
  final int reviews;
  final String? heroTag;

  const ProductScreen({
    super.key,
    required this.productName,
    required this.image,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.productId,
    this.heroTag,
  });

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
            productId: widget.productId,
            image: widget.image,
            heroTag: widget.heroTag ?? "",
            onBack: () => Navigator.pop(context),
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
                      productName: widget.productName,
                      price: widget.price,
                      description: widget.description,
                      rating: widget.rating,
                      reviews: widget.reviews,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: CustomButton(
          onPressed: () {},
          height: 50,
          width: double.infinity,
          text: "BUY",
        ),
      ),
    );
  }
}
