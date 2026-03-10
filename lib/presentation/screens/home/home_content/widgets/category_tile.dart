import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  const CategoryTile({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const .symmetric(horizontal: 20),
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: .circular(25),
        border: .all(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withValues(alpha: 0.5),
          width: 1.5,
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
      alignment: .center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected ? AppColors.textDark : AppColors.textLight,
          fontWeight: isSelected ? .w700 : .w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
