import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductBottomNavbar extends StatelessWidget {
  final ProductModel product;
  final String selectedSize;
  final int quantity;
  const ProductBottomNavbar({
    super.key,
    required this.product,
    required this.selectedSize, required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
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
            child: CustomButton(
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
                await context.read<CartProvider>().addToCart(
                  product,
                  selectedSize,
                  quantity,
                );
              },
              height: 50,
              width: double.infinity,
              text: "Add to Cart",
            ),
          ),
        ],
      ),
    );
  }
}
