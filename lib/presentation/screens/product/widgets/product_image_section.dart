import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductImageSection extends StatelessWidget {
  final String productId;
  final String image;
  final String heroTag;

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
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: .circular(30),
          ),
          child: Stack(
            fit: .expand,
            children: [
              CachedNetworkImage(
                imageUrl: image,
                fit: .cover,
                filterQuality: .high,
                colorBlendMode: .darken,
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

              Positioned(
                bottom: 20,
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
        ),
      ),
    );
  }
}
