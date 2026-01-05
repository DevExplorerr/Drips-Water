// product_screen.dart

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/home/cart/cart_screen.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_bottom_sheet.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/widgets/icon_badge/cart_icon_badge.dart'; // Ensure correct import
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.3,
            pinned: true, // This keeps the back and cart button visible
            stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,

            // 1. Back Button (Pinned Left)
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // 2. Cart Button (Pinned Right)
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CartIconBadge(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: AppColors.primary,
                      badgeColor: AppColors.primary,
                      textColor: Colors.white,
                      width: 15, // Adjusted for small circle
                      height: 15,
                      left: 15, // Adjust badge position
                      bottom: 15,
                    ),
                  ),
                ),
              ),
            ],

            // 3. Image + Favorite (Scrolls Away)
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: ProductImageSection(
                productId: widget.product.id,
                image: widget.product.imageUrl,
                heroTag: widget.heroTag ?? "",
              ),
            ),
          ),

          // Product Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
                bottom: 50,
              ),
              child: Column(
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
        ],
      ),
      bottomNavigationBar: ProductBottomNavbar(
        onBuyNowPressed: () => _openBottomSheet(ProductAction.buyNow),
        onAddToCartPressed: () => _openBottomSheet(ProductAction.addToCart),
      ),
    );
  }
}
