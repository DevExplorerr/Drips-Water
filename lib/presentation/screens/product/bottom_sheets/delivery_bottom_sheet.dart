import 'package:drips_water/presentation/screens/product/bottom_sheets/sheet_header.dart';
import 'package:flutter/material.dart';

class DeliveryBottomSheet extends StatelessWidget {
  const DeliveryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHeader(title: "Delivery"),

            const SizedBox(height: 20),

            const _RowItem(
              title: "Deliver To",
              value: "Block 15",
              icon: Icons.location_on_outlined,
            ),

            const Divider(height: 30),

            Text("Delivery Fee", style: textTheme.titleMedium),
            const SizedBox(height: 10),

            const _RowItem(
              title: "Standard Delivery",
              subtitle: "Guaranteed by 3-5 Jan",
              value: "Rs. 165",
            ),
            const SizedBox(height: 12),
            const _RowItem(
              title: "Standard Collection Point",
              subtitle: "Guaranteed by 3-5 Jan",
              value: "Rs. 50",
            ),

            const Divider(height: 30),

            Text("Delivery Service", style: textTheme.titleMedium),
            const SizedBox(height: 10),
            const Text("Cash on Delivery available"),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final IconData? icon;

  const _RowItem({required this.title, this.subtitle, this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.bodyLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: textTheme.bodySmall),
              ],
            ],
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
