import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryTile({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: isSelected
              ? Colors.white
              : AppColors.textLight.withValues(alpha: 0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
