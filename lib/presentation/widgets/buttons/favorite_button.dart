// ignore_for_file: deprecated_member_use

import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
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
    required this.iconSize,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, fav, _) {
        final isFavorite = fav.isFavorite(productId);
        return GestureDetector(
          onTap: () async {
            final success = await fav.toggleFavorite(productId);
            if (!success && context.mounted) {
              showDialog(
                context: context,
                animationStyle: AnimationStyle(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 200),
                ),
                builder: (context) => const CustomLoginPromptDialog(
                  message:
                      "You need to sign in to add products to your favorites.",
                ),
              );
            }
          },
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.5),
              borderRadius: .circular(6),
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.favorite,
              size: iconSize,
            ),
          ),
        );
      },
    );
  }
}
