import 'package:drips_water/presentation/screens/product/bottom_sheets/sheet_header.dart';
import 'package:flutter/material.dart';

class ServiceBottomSheet extends StatelessWidget {
  const ServiceBottomSheet({super.key});

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
            const SheetHeader(title: "Service"),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.verified_outlined),
                const SizedBox(width: 10),
                Text("14 days easy return", style: textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              "Drips Water guarantees that all purchased products are genuine, brand new and not defective. In case the product is defective or incorrect, it can be returned within 14 days.",
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
