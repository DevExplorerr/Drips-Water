import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/bouncing_dots.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.android, size: 16, color: AppColors.white),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.bot,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const BouncingDots(),
        ),
      ],
    );
  }
}
