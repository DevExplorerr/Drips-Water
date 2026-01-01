import 'package:drips_water/presentation/screens/product/bottom_sheets/sheet_header.dart';
import 'package:flutter/material.dart';

class DeliveryBottomSheet extends StatelessWidget {
  const DeliveryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const .only(right: 15, left: 15, top: 5, bottom: 25),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            const SheetHeader(title: "Delivery"),

            const SizedBox(height: 25),

            const _RowItem(
              title: "Deliver To",
              value: "XYZ",
              icon: Icons.location_on_outlined,
            ),

            const Divider(height: 30),

            Text("Delivery Fee", style: textTheme.titleSmall),
            const SizedBox(height: 15),

            const _RowItem(
              title: "Standard Delivery",
              subtitle: "Guaranteed by 3-5 Jan",
              value: "\$30",
            ),
            const SizedBox(height: 12),
            const _RowItem(
              title: "Standard Collection Point",
              subtitle: "Guaranteed by 3-5 Jan",
              value: "\$10",
            ),

            const Divider(height: 30),

            Text("Delivery Service", style: textTheme.titleSmall),
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
      crossAxisAlignment: .start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [Text(title, style: textTheme.bodyMedium)],
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: textTheme.bodyMedium?.copyWith(fontWeight: .w600),
          ),
      ],
    );
  }
}
