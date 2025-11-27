// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/model/product_model.dart';
import 'package:drips_water/presentation/screens/product/product_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String heroTag = '${product.id}_ProductCard';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductScreen(heroTag: heroTag, product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: heroTag,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      colorBlendMode: BlendMode.darken,
                      color: AppColors.black.withOpacity(0.05),
                      placeholder: (_, __) =>
                          LoadingAnimationWidget.threeArchedCircle(
                            color: AppColors.primary,
                            size: 30,
                          ),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: AppColors.icon),
                    ),
                  ),

                  // Favorite Icon
                  Positioned(
                    top: 10,
                    right: 12,
                    child: FavoriteButton(
                      productId: product.id,
                      iconSize: 18,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('\$${product.price}', style: textTheme.bodyMedium),
            ),
            const SizedBox(height: 8),

            // Rating & Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.review, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "(${product.reviews})",
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
