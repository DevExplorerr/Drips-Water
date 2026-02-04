import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth > 320
            ? 300
            : constraints.maxWidth;
        return Container(
          height: 150,
          width: cardWidth,
          decoration: const BoxDecoration(
            borderRadius: .all(.circular(14)),
            color: AppColors.primary,
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [AppColors.primary, Color(0xFF1E88E5)],
            ),
          ),
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
              const SizedBox(height: 5),
              Text(
                cardNumber,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: .w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
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
        );
      },
    );
  }
}
