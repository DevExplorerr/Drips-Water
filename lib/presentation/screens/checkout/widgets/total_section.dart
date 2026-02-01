import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalSection extends StatelessWidget {
  final double? overrideTotal;
  const TotalSection({super.key, this.overrideTotal});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cartProvider = context.watch<CartProvider>();
    final checkoutProvider = context.watch<CheckoutProvider>();

    final subTotal = overrideTotal ?? cartProvider.totalPrice;

    final deliveryFees = checkoutProvider.deliveryFee;
    final double discount = checkoutProvider.calculateDiscount(subTotal);
    final double finalTotal = checkoutProvider.calculateFinalTotal(subTotal);
    return Column(
      children: [
        _buildRow("Subtotal", subTotal, textTheme),
        const SizedBox(height: 10),
        _buildRow("Delivery", deliveryFees, textTheme),

        if (discount > 0) ...[
          const SizedBox(height: 10),
          _buildRow("Discount", -discount, textTheme, isDiscount: true),
        ],

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(),
        ),

        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "Total",
              style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
            ),
            Text(
              "\$${finalTotal.toStringAsFixed(2)}",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: .w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(
    String label,
    double value,
    TextTheme textTheme, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.secondaryText,
            fontWeight: .w700,
          ),
        ),
        Text(
          "${isDiscount ? '-' : ''}\$${value.abs().toStringAsFixed(2)}",
          style: textTheme.bodySmall?.copyWith(
            fontWeight: .w700,
            color: isDiscount ? AppColors.success : AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
