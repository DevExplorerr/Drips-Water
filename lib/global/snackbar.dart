import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

void showFloatingSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 1),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action: action,
    ),
  );
}
