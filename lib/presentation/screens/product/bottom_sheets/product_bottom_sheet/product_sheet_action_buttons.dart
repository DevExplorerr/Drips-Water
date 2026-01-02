import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductSheetActionButtons extends StatelessWidget {
  final ProductAction action;
  final bool isLoading;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductSheetActionButtons({
    super.key,
    required this.action,
    required this.isLoading,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppColors.primary,
          size: 40,
        ),
      );
    }

    final showAddToCart =
        action == ProductAction.addToCart || action == ProductAction.all;
    final showBuyNow =
        action == ProductAction.buyNow || action == ProductAction.all;

    return Row(
      children: [
        if (showBuyNow)
          Expanded(
            child: CustomButton(
              height: 50,
              width: .infinity,
              color: AppColors.primary,
              text: "Buy Now",
              onPressed: onBuyNow,
            ),
          ),

        if (showAddToCart && showBuyNow) const SizedBox(width: 10),

        if (showAddToCart)
          Expanded(
            child: CustomButton(
              height: 50,
              width: .infinity,
              // Todo: will add a outlined border
              color: AppColors.primary,
              text: "Add to Cart",
              onPressed: onAddToCart,
            ),
          ),
      ],
    );
  }
}
