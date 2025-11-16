import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String description;
  final CrossAxisAlignment crossAxisAlignment;
  const Header({
    super.key,
    required this.title,
    required this.description,
    required this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
