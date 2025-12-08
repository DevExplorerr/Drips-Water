// qty_button.dart
import 'package:flutter/material.dart';
import 'package:drips_water/core/constants/app_colors.dart';

class QtyButton extends StatelessWidget {
  final IconData icon;
  const QtyButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: AppColors.actionButton,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: theme.iconTheme.color),
    );
  }
}
