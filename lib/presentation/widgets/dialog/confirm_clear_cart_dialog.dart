// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ConfirmClearCartDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;
  const ConfirmClearCartDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Premium Circular Icon
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              size: 34,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text("Clear Cart?", style: textTheme.titleLarge),

          const SizedBox(height: 10),

          // Description
          Text(
            "Do you really want to remove all items from your cart? This action cannot be undone.",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: AppColors.secondaryText,
            ),
          ),

          const SizedBox(height: 25),

          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: cart.isClearingCart
                      ? null
                      : () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: cart.isClearingCart
                    ? LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primary,
                        size: 35,
                      )
                    : CustomButton(
                        height: 40,
                        width: 40,
                        text: "Clear",
                        onPressed: () async {
                          await onConfirm();
                          if (context.mounted) {
                            Navigator.pop(context);
                            showFloatingSnackBar(
                              context,
                              message: "Cart cleared successfully",
                              backgroundColor: theme.primaryColor,
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
