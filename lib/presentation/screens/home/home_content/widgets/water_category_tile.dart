import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WaterCategoryTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  const WaterCategoryTile({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 40,
      width: 90,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.black : AppColors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Center(
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
