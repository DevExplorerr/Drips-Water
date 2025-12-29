import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/widgets/common/app_badge.dart';
import 'package:drips_water/presentation/widgets/common/info_tile.dart';
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
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: .spaceBetween,
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
        const SizedBox(height: 15),
        Row(
          children: [
            Text(
              '\$$price',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(width: 10),
            AppBadge(
              text: selectedSize,
              padding: const .symmetric(horizontal: 10, vertical: 4),
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.1),
              textStyle: textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: .w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
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
        const SizedBox(height: 30),

        InfoTile(
          icon: Icons.verified_outlined,
          title: "14 days easy return",
          topLeft: .circular(12),
          topRight: .circular(12),
          bottomLeft: .circular(0),
          bottomRight: .circular(0),
          onTap: () {},
        ),
        InfoTile(
          icon: Icons.local_shipping_outlined,
          title: "Guaranteed by 3-5 Jan",
          subtitle: "Standard Delivery",
          trailingText: "\$30",
          topLeft: .circular(0),
          topRight: .circular(0),
          bottomLeft: .circular(0),
          bottomRight: .circular(0),
          onTap: () {},
        ),
        InfoTile(
          icon: Icons.inventory_2_outlined,
          title: 'Size: 100ml',
          showArrow: true,
          topLeft: .circular(0),
          topRight: .circular(0),
          bottomLeft: .circular(12),
          bottomRight: .circular(12),
          onTap: () {},
        ),

        const SizedBox(height: 30),
        Text(product.description, style: textTheme.bodyMedium),
      ],
    );
  }
}
