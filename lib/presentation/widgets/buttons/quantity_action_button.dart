import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QuantityActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const QuantityActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 45,
    this.iconSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: AppColors.actionButton,
          borderRadius: .circular(5),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
          size: iconSize,
        ),
      ),
    );
  }
}
