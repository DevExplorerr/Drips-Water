// product_bottom_navbar.dart
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProductBottomNavbar extends StatelessWidget {
  final VoidCallback onBuyNowPressed;
  final VoidCallback onAddToCartPressed;

  const ProductBottomNavbar({
    super.key,
    required this.onBuyNowPressed,
    required this.onAddToCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              height: 50,
              width: .infinity,
              text: "Buy Now",
              buttonColor: AppColors.white,
              textColor: AppColors.primary,
              elevation: 0,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
              onPressed: onBuyNowPressed,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomButton(
              height: 50,
              width: .infinity,
              text: "Add to Cart",
              onPressed: onAddToCartPressed,
            ),
          ),
        ],
      ),
    );
  }
}
