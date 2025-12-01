import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductOptionSection extends StatelessWidget {
  final int quantity;
  final String selectedSize;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;

  const ProductOptionSection({
    super.key,
    required this.quantity,
    required this.selectedSize,
    required this.onQuantityChanged,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bottle Size
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bottle size",
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedSize,
                dropdownColor: AppColors.white,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
                items: ["100ml", "500ml", "1L", "5L"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => onSizeChanged(val!),
              ),
            ),
          ],
        ),

        // Quantity Selector
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quantity",
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _qtyButton(context, Icons.remove, () {
                  if (quantity > 1) onQuantityChanged(quantity - 1);
                }),
                const SizedBox(width: 20),
                Text(
                  quantity.toString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(width: 20),
                _qtyButton(context, Icons.add, () {
                  onQuantityChanged(quantity + 1);
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _qtyButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: AppColors.actionButton,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 25),
      ),
    );
  }
}
