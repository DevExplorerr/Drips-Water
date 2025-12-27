import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;
  final int price;
  final String selectedSize;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.price,
    required this.selectedSize,
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
            Text(product.name, style: textTheme.titleLarge),
            Text(
              "Stock: ${product.stock}",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '\$$price',
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedSize,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text(product.description, style: textTheme.bodyMedium),
        const SizedBox(height: 25),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.review, size: 25),
            const SizedBox(width: 4),
            Text(
              product.rating.toString(),
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              "(${product.reviews})",
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
