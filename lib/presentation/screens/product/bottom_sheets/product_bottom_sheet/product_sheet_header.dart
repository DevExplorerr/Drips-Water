import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductSheetHeader extends StatelessWidget {
  final String imageUrl;
  final int price;
  final String selectedSize;

  const ProductSheetHeader({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const .only(left: 15.0, top: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: .circular(20.0),
            child: CachedNetworkImage(
              width: 90,
              height: 90,
              fit: .cover,
              filterQuality: .high,
              imageUrl: imageUrl,
              placeholder: (context, url) => Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              errorWidget: (_, __, ___) => const Icon(
                Icons.broken_image,
                color: AppColors.icon,
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$$price",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: .w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                selectedSize,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
