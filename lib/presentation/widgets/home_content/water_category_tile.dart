import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WaterCategoryTile extends StatelessWidget {
  final Color color;
  final String text;
  const WaterCategoryTile({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      alignment: Alignment.center,
      child: Center(
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
