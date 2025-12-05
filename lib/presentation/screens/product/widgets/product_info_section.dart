import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final String productName;
  final String description;
  final double price;
  final double rating;
  final int reviews;
  final int stock;

  const ProductInfoSection({
    super.key,
    required this.productName,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(productName, style: textTheme.titleLarge),
            Text(
              "Stock: $stock",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '\$$price',
          style: textTheme.titleSmall?.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 25),
        Text(description, style: textTheme.bodyMedium),
        const SizedBox(height: 25),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.review, size: 25),
            const SizedBox(width: 4),
            Text(
              rating.toString(),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              "($reviews)",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
