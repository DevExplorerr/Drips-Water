import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartProductCard extends StatelessWidget {
  final CartItemModel product;
  const MyCartProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 85,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider(product.imageUrl),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    product.name,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
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
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      cart.decrease(product.productId, product.selectedSize);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: actionButton(theme, icon: Icons.remove),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Text(
                    product.quantity.toString(),
                    style: textTheme.bodySmall?.copyWith(fontFamily: "Inter"),
                  ),
                  const SizedBox(width: 13),
                  GestureDetector(
                    onTap: () async {
                      cart.addToCart(
                        ProductModel(
                          id: product.productId,
                          name: product.name,
                          imageUrl: product.imageUrl,
                          category: '',
                          description: '',
                          sizes: [product.selectedSize],
                          price: product.price,
                          rating: 0,
                          reviews: 0,
                          isFavorite: false,
                          stock: 0,
                        ),
                        product.selectedSize,
                        1,
                      );
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: actionButton(theme, icon: Icons.add),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      cart.deleteItem(product.productId, product.selectedSize);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: actionButton(theme, icon: Icons.delete_outline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget actionButton(ThemeData theme, {required IconData icon}) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: AppColors.actionButton,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(icon, size: 15, color: theme.iconTheme.color),
    );
  }
}


    // if (!snapshot.hasData) {
    //   return const Padding(
    //     padding: EdgeInsets.all(8.0),
    //     child: SizedBox(
    //       height: 80,
    //       child: Center(child: CircularProgressIndicator()),
    //     ),
    //   );
    // }
    // final p = snapshot.data!;