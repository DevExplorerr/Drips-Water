// product_screen.dart

import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/home/cart/cart_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_sheet.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
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
  late String selectedSize;
  late int selectedPrice;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.sizes.first;
    selectedPrice = widget.product.pricePerSize[selectedSize]!;
  }

  void onSizeChanged(String size) {
    setState(() {
      selectedSize = size;
      selectedPrice = widget.product.pricePerSize[size]!;
    });
  }

  void _openBottomSheet(ProductAction action) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ProductBottomSheet(
          product: widget.product,
          initialSize: selectedSize,
          initialQuantity: quantity,
          action: action,
          onSizeChanged: onSizeChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          ProductImageSection(
            productId: widget.product.id,
            image: widget.product.imageUrl,
            heroTag: widget.heroTag ?? "",
            onBack: () => Navigator.pop(context),
            onNavigate: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const CartScreen()),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const .only(left: 15, right: 15, top: 20, bottom: 50),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    ProductInfoSection(
                      product: widget.product,
                      price: selectedPrice,
                      selectedSize: selectedSize,
                      onSizeTap: () => _openBottomSheet(ProductAction.all),
                      onSizeChanged: onSizeChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductBottomNavbar(
        onBuyNowPressed: () => _openBottomSheet(ProductAction.buyNow),
        onAddToCartPressed: () => _openBottomSheet(ProductAction.addToCart),
      ),
    );
  }
}
