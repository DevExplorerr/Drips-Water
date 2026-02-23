// ignore_for_file: deprecated_member_use

import 'package:drips_water/logic/view_models/home/home_app_bar_view_model.dart';
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
            if (context.read<HomeAppBarViewModel>().isGuest) {
              showDialog(
                context: context,
                animationStyle: AnimationStyle(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 200),
                ),
                builder: (_) => const CustomLoginPromptDialog(
                  message:
                      "You need to sign in to add products to your favorites.",
                ),
              );
              return;
            }
            await fav.toggleFavorite(productId);
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
