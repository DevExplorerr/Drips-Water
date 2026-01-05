// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductImageSection extends StatelessWidget {
  final String productId;
  final String image;
  final String heroTag;

  // Removed onBack and onNavigate because they are now in the AppBar
  const ProductImageSection({
    super.key,
    required this.image,
    required this.productId,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Stack(
        fit: StackFit.expand, // Ensures image fills the FlexibleSpaceBar
        children: [
          // 1. Product Image
          CachedNetworkImage(
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
            errorWidget: (_, __, ___) =>
                const Icon(Icons.broken_image, color: AppColors.icon, size: 50),
          ),

          // 2. Favorite Button (Scrolls away with image)
          // Positioned slightly lower than the AppBar buttons so they don't overlap initially
          Positioned(
            top: 150,
            right: 15,
            child: FavoriteButton(
              productId: productId,
              iconSize: 25,
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),
    );
  }
}
