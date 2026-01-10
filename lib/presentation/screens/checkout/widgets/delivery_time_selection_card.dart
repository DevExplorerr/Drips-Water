import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryTimeSelectionCard extends StatelessWidget {
  final double width;
  final String text;
  final String time;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  const DeliveryTimeSelectionCard({
    super.key,
    required this.width,
    required this.text,
    required this.time,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .all(6),
        height: 60,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(10),
          border: .all(color: isSelected ? AppColors.primary : AppColors.black),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  text,
                  style: textTheme.bodySmall?.copyWith(fontWeight: .w500),
                ),
                Text(
                  time,
                  style: textTheme.bodySmall?.copyWith(fontFamily: 'Inter'),
                ),
              ],
            ),
            Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_sharp,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
