import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/sheet_header.dart';
import 'package:flutter/material.dart';

class ServiceBottomSheet extends StatelessWidget {
  const ServiceBottomSheet({super.key});

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
            const SheetHeader(title: "Service"),

            const SizedBox(height: 25),

            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: .circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "14 days easy return",
                      style: textTheme.bodyMedium?.copyWith(fontWeight: .w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Drips Water guarantees that all purchased products are genuine, brand new and not defective. In case the product is defective or incorrect, it can be returned within 14 days.",
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
