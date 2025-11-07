// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/favorite_provider.dart';

class FavoriteButton extends StatelessWidget {
  final String productId;
  final double iconSize;
  final double height;
  final double width;

  const FavoriteButton({
    super.key,
    required this.productId,
    required this.iconSize, required this.height, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final isFavorite = provider.isFavorite(productId);

    return GestureDetector(
      onTap: () => provider.toggleFavorite(productId),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: AppColors.favorite,
          size: iconSize,
        ),
      ),
    );
  }
}
