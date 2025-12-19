import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProductBottomNavbar extends StatelessWidget {
  final ProductModel product;
  final String selectedSize;
  final int quantity;
  const ProductBottomNavbar({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final isAdding = context.select<CartProvider, bool>(
      (cart) => cart.isAdding,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              color: AppColors.grey,
              onPressed: () {},
              height: 50,
              width: double.infinity,
              text: "Buy Now",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isAdding
                ? LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primary,
                    size: 45,
                  )
                : CustomButton(
                    height: 50,
                    width: double.infinity,
                    text: "Add to Cart",
                    onPressed: () async {
                      if (selectedSize.isEmpty) {
                        showFloatingSnackBar(
                          context,
                          message: "Please select a size",
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                        );
                        return;
                      }

                      final response = await context
                          .read<CartProvider>()
                          .addToCart(product, selectedSize, quantity);

                      if (!context.mounted) return;

                      showFloatingSnackBar(
                        context,
                        message: response.message,
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.primary,
                      );

                      if (response.status == CartStatus.guestBlocked) {
                        showDialog(
                          context: context,
                          animationStyle: AnimationStyle(
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 300),
                            reverseDuration: const Duration(milliseconds: 200),
                          ),
                          builder: (_) => CustomLoginPromptDialog(
                            message: response.message,
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
