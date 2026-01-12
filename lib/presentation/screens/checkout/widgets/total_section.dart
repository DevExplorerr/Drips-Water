import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalSection extends StatelessWidget {
  const TotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cartProvider = context.watch<CartProvider>();

    final subTotal = cartProvider.totalPrice;
    const deliveryFees = 5.00;
    final totalPrice = subTotal + deliveryFees;
    return Column(
      children: [
        _buildRow(context, "Subtotal", "\$${subTotal.toStringAsFixed(2)}"),
        const SizedBox(height: 10),
        _buildRow(context, "Delivery", "\$${deliveryFees.toStringAsFixed(2)}"),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "Total",
              style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
            ),
            Text(
              totalPrice.toString(),
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

  Widget _buildRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
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
          value,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.secondaryText,
            fontWeight: .w700,
          ),
        ),
      ],
    );
  }
}
