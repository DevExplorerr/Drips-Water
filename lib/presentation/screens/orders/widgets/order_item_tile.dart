import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderItemTile extends StatelessWidget {
  final CartItemModel item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .symmetric(vertical: 10),
      child: Row(
        children: [
          // Styled Image Container
          Container(
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              color: AppColors.grey.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: .circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 65,
                height: 65,
                fit: .cover,
                placeholder: (_, __) =>
                    LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.primary,
                      size: 30,
                    ),
                errorWidget: (_, _, _) => const Icon(
                  Icons.water_drop,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  item.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.selectedSize}  •  Qty: ${item.quantity}",
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Price Section
          Text(
            "\$${(item.selectedPrice * item.quantity).toStringAsFixed(2)}",
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: .w700,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
