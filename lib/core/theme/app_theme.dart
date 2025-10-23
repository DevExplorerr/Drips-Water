// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    cardColor: AppColors.card,
    fontFamily: 'Poppins',
    textTheme: appTextTheme,

    // Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        overlayColor: WidgetStatePropertyAll(AppColors.white.withOpacity(0.1)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(AppColors.black.withOpacity(0.1)),
      ),
    ),

    // App bar
    appBarTheme: const AppBarThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    )
  );
}
