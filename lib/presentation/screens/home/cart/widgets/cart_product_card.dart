// cart_product_card.dart
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/fade_slide_wrapper.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/scale_button.dart';
import 'package:drips_water/presentation/widgets/buttons/quantity_action_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CartProductCard extends StatelessWidget {
  final CartItemModel product;
  const CartProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return FadeSlideWrapper(
      child: Dismissible(
        key: Key("${product.productId}-${product.selectedSize}"),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(Icons.delete, color: AppColors.red, size: 28),
        ),
        onDismissed: (_) {
          cart.deleteItem(product.productId, product.selectedSize);
        },
        child: _buildCard(context, cart),
      ),
    );
  }

  Widget _buildCard(BuildContext context, CartProvider cart) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              placeholder: (context, url) => Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.primary,
                  size: 50,
                ),
              ),
              errorWidget: (_, __, ___) => const Icon(
                Icons.broken_image,
                color: AppColors.icon,
                size: 50,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME + SIZE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      product.selectedSize,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  "\$${product.price}",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    ScaleButton(
                      onTap: () => cart.decrease(
                        product.productId,
                        product.selectedSize,
                      ),
                      child: AbsorbPointer(
                        child: QuantityActionButton(
                          icon: Icons.remove,
                          size: 30,
                          iconSize: 20,
                          onTap: () {},
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Text(
                      product.quantity.toString(),
                      style: textTheme.bodySmall?.copyWith(fontFamily: "Inter"),
                    ),

                    const SizedBox(width: 14),

                    ScaleButton(
                      onTap: () {
                        cart.addToCart(
                          ProductModel(
                            id: product.productId,
                            name: product.name,
                            imageUrl: product.imageUrl,
                            category: '',
                            description: '',
                            sizes: [product.selectedSize],
                            pricePerSize: {
                              product.selectedSize: product.selectedPrice,
                            },
                            price: product.price,
                            rating: 0,
                            reviews: 0,
                            stock: 0,
                          ),
                          product.selectedSize,
                          1,
                        );
                      },
                      child: AbsorbPointer(
                        child: QuantityActionButton(
                          icon: Icons.add,
                          size: 30,
                          iconSize: 20,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
