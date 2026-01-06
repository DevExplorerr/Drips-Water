import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HeaderIcon extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  const HeaderIcon({super.key, this.icon, this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        alignment: .center,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.5),
          borderRadius: .circular(6),
        ),
        child: child ?? Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
