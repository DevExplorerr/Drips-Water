import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_sheet.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProductBottomNavbar extends StatelessWidget {
  final ProductModel product;
  const ProductBottomNavbar({super.key, required this.product});

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
              color: AppColors.primary,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ProductBottomSheet(
                      product: product,
                      action: .buyNow,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomButton(
              height: 50,
              width: .infinity,
              text: "Add to Cart",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ProductBottomSheet(
                      product: product,
                      action: .addToCart,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum ProductAction { addToCart, buyNow }
