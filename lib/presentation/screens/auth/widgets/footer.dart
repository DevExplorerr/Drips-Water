import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  const Footer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onTap,
          child: Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
