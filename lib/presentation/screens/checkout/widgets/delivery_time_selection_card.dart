import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';

class DeliveryTimeSelectionCard extends StatefulWidget {
  final double width;
  final String text;
  final String time;
  final String value;
  const DeliveryTimeSelectionCard({
    super.key,
    required this.width,
    required this.text,
    required this.time,
    required this.value,
  });

  @override
  State<DeliveryTimeSelectionCard> createState() =>
      _DeliveryTimeSelectionCardState();
}

class _DeliveryTimeSelectionCardState extends State<DeliveryTimeSelectionCard> {
  String deliveryOption = "standard";
  bool get isSelected => deliveryOption == widget.value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          deliveryOption = widget.value;
          showCalendar = widget.value == "schedule";
        });
      },
      child: Container(
        padding: const .all(6),
        height: 60,
        width: widget.width,
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
                  widget.text,
                  style: textTheme.bodySmall?.copyWith(fontWeight: .w500),
                ),
                Text(
                  widget.time,
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
