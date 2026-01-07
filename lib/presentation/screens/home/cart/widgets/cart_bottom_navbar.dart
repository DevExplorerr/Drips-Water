import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBottomNavbar extends StatelessWidget {
  const CartBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const .all(15),
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: .circular(20),
          topRight: .circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Text(
                  "SUBTOTAL (${cart.cartItems.length} items)",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${cart.totalPrice.toStringAsFixed(0)}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomButton(
              onPressed: () {
                if (cart.cartItems.isEmpty) return;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              color: cart.cartItems.isEmpty
                  ? AppColors.grey.withValues(alpha: 0.3)
                  : AppColors.primary,
              height: 50,
              width: .infinity,
              text: "CHECKOUT",
            ),
          ),
        ],
      ),
    );
  }
}
