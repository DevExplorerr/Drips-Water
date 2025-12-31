import 'package:drips_water/presentation/screens/product/bottom_sheets/sheet_header.dart';
import 'package:flutter/material.dart';

class ServiceBottomSheet extends StatelessWidget {
  const ServiceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(right: 15, left: 15, top: 15, bottom: 25),
      child: Column(
        mainAxisSize: .min,
        children: [
          const SheetHeader(title: "Service"),

          const SizedBox(height: 25),

          Row(
            children: [
              const Icon(Icons.verified_outlined),
              const SizedBox(width: 10),
              Text("14 days easy return", style: textTheme.titleSmall),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            "Drips Water guarantees that all purchased products are genuine, brand new and not defective. In case the product is defective or incorrect, it can be returned within 14 days.",
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
