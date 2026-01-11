import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/widgets/buttons/quantity_action_button.dart';
import 'package:drips_water/presentation/widgets/common/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckoutProductCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final String selectedSize;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CheckoutProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.selectedSize,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const .all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: .circular(10),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: .cover,
                filterQuality: .high,
                colorBlendMode: .darken,
                placeholder: (context, url) => Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: AppColors.icon,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "\$${product.price.toString()}",
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: .w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppBadge(
                      text: selectedSize,
                      padding: const .symmetric(horizontal: 8, vertical: 2),
                      color: AppColors.primary.withValues(alpha: 0.1),
                      textStyle: textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: [
              QuantityActionButton(
                icon: Icons.remove,
                onTap: onDecrement ?? () {},
                size: 30,
                iconSize: 15,
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    "$quantity",
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: .w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
              QuantityActionButton(
                icon: Icons.add,
                onTap: onIncrement ?? () {},
                size: 30,
                iconSize: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
