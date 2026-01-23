import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  const CreditCard({
    super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 140,
      width: 270,
      decoration: const BoxDecoration(
        borderRadius: .all(.circular(14)),
        color: AppColors.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1E88E5)],
        ),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              cardType,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              cardNumber,
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
                      cardHolderName,
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
                      expiryDate,
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
