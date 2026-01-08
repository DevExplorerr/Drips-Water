import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 140,
      width: 270,
      decoration: const BoxDecoration(
        borderRadius: .all(.circular(14)),
        color: AppColors.primary,
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "VISA",
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "****  ****  ****  ****  3282",
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Card Holder",
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Saad Jamal",
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: .w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Expires",
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "12/23",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
