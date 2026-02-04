import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentSection({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(12),
          border: .all(
            color: isSelected ? AppColors.primary : AppColors.grey,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const .symmetric(horizontal: 15),
        child: Row(
          children: [
            // Radio Circle
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: .circle,
                border: .all(
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: .circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            // Title
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: .w600,
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                ),
              ),
            ),
            Icon(icon, size: 24),
          ],
        ),
      ),
    );
  }
}
