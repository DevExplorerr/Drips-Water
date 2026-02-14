import 'package:flutter/material.dart';
import 'package:drips_water/core/constants/app_colors.dart';

class TrackingStepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const TrackingStepItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                padding: const .all(10),
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.2),
                  shape: .circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isCompleted || isCurrent
                      ? AppColors.white
                      : AppColors.grey,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    thickness: 2,
                    width: 2,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 8),
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCurrent ? AppColors.primary : AppColors.textLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
