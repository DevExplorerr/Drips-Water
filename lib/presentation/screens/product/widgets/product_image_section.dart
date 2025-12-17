// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:drips_water/presentation/widgets/icon_badge/cart_icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductImageSection extends StatelessWidget {
  final String productId;
  final String image;
  final VoidCallback onBack;
  final VoidCallback onNavigate;
  final String heroTag;

  const ProductImageSection({
    super.key,
    required this.image,
    required this.onBack,
    required this.productId,
    required this.heroTag,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
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
            child: GestureDetector(
              onTap: onNavigate,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: CartIconBadge(
                    icon: Icons.shopping_bag_outlined,
                    iconColor: AppColors.primary,
                    badgeColor: AppColors.primary,
                    textColor: AppColors.textDark,
                    width: 20,
                    height: 20,
                    left: 20,
                    bottom: 20,
                  ),
                ),
              ),
            ),
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
