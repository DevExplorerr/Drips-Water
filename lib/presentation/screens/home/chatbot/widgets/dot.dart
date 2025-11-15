import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: const BoxDecoration(
        color: AppColors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
