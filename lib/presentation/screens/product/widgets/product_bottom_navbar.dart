import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ProductBottomNavbar extends StatelessWidget {
  const ProductBottomNavbar({super.key});

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
              onPressed: () {},
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
