import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TimeContainer extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;
  const TimeContainer({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: .all(Radius.circular(6)),
          color: isSelected ? AppColors.primary : AppColors.white,
        ),
        child: Center(
          child: Text(
            time,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isSelected ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
