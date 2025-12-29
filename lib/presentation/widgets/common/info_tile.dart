import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showArrow;
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.onTap,
    this.showArrow = true,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12),
      child: Container(
        padding: const .all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: .only(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Icon(icon, size: 22, color: theme.primaryColor),
            const SizedBox(width: 12),

            // Main text
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing
            Column(
              crossAxisAlignment: .end,
              children: [
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
                  ),
                if (showArrow)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: theme.iconTheme.color,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
