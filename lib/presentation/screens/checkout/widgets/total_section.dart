import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TotalSection extends StatelessWidget {
  const TotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Sub Total",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Delivery fee",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
                fontWeight: .w700,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "\$100",
              style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
            ),
            const SizedBox(height: 10),
            Text(
              "\$10",
              style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
            ),
            const SizedBox(height: 10),
            Text(
              "\$110",
              style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
            ),
          ],
        ),
      ],
    );
  }
}
