import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const MessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isUser ? AppColors.primary : AppColors.bot;
    final textColor = isUser ? AppColors.textDark : AppColors.textLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
