// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_outline,
              color: AppColors.primary,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No favorites yet",
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Add some products you love",
            style: textTheme.bodySmall?.copyWith(
              fontFamily: 'Inter',
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
