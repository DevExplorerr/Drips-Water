// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String image;
  final int price;
  final String description;
  final double rating;
  final int reviews;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.image,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String selectedSize = "100ml";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageSection(
            productId: widget.productId,
            image: widget.image,
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
                    ProductInfoSection(
                      productName: widget.productName,
                      price: widget.price,
                      description: widget.description,
                      rating: widget.rating,
                      reviews: widget.reviews,
                    ),

                    const SizedBox(height: 25),

                    // Options (Bottle Size + Quantity)
                    ProductOptionsRow(
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

class ProductImageSection extends StatelessWidget {
  final String productId;
  final String image;
  final VoidCallback onBack;

  const ProductImageSection({
    super.key,
    required this.image,
    required this.onBack,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: productId,
      child: Stack(
        children: [
          // Product Image
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              colorBlendMode: BlendMode.darken,
              placeholder: (context, url) => Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.primary,
                  size: 50,
                ),
              ),
              errorWidget: (_, __, ___) => const Icon(
                Icons.broken_image,
                color: AppColors.icon,
                size: 50,
              ),
            ),
          ),

          // Back + Favorite (top row)
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(Icons.arrow_back, onBack),
                FavoriteButton(
                  productId: productId,
                  iconSize: 25,
                  height: 45,
                  width: 45,
                ),
              ],
            ),
          ),

          // Cart Button
          Positioned(
            bottom: 20,
            right: 15,
            child: _buildIconButton(Icons.shopping_bag_outlined, () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 25),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final String productName;
  final int price;
  final String description;
  final double rating;
  final int reviews;

  const ProductInfoSection({
    super.key,
    required this.productName,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(productName, style: textTheme.titleLarge),
            Text(
              "(In Stock)",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('\$$price', style: textTheme.titleSmall),
        const SizedBox(height: 25),
        Text(description, style: textTheme.bodyMedium),
        const SizedBox(height: 25),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.review, size: 25),
            const SizedBox(width: 4),
            Text(
              rating.toString(),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              "($reviews)",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductOptionsRow extends StatelessWidget {
  final int quantity;
  final String selectedSize;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;

  const ProductOptionsRow({
    super.key,
    required this.quantity,
    required this.selectedSize,
    required this.onQuantityChanged,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bottle Size
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bottle size",
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedSize,
                dropdownColor: AppColors.white,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
                items: ["100ml", "500ml", "1L", "5L"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => onSizeChanged(val!),
              ),
            ),
          ],
        ),

        // Quantity Selector
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quantity",
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _qtyButton(context, Icons.remove, () {
                  if (quantity > 1) onQuantityChanged(quantity - 1);
                }),
                const SizedBox(width: 20),
                Text(
                  quantity.toString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(width: 20),
                _qtyButton(context, Icons.add, () {
                  onQuantityChanged(quantity + 1);
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _qtyButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 25),
      ),
    );
  }
}
