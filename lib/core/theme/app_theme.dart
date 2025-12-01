// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    cardColor: AppColors.card,
    fontFamily: 'Poppins',
    textTheme: appTextTheme,

    // Card
    cardTheme: const CardThemeData(color: AppColors.card),

    // Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        overlayColor: WidgetStatePropertyAll(AppColors.white.withOpacity(0.1)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 18,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
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
        fontFamily: "Poppins",
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Icon
    iconTheme: const IconThemeData(color: AppColors.icon),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(AppColors.black.withOpacity(0.1)),
      ),
    ),

    // TextField
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.grey.withOpacity(0.5),
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      hintStyle: appTextTheme.bodySmall?.copyWith(
        color: AppColors.secondaryText,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.enabledBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.focusedBorder),
      ),
    ),

    // Search Bar
    searchBarTheme: SearchBarThemeData(
      backgroundColor: const WidgetStatePropertyAll(AppColors.background),
      elevation: const WidgetStatePropertyAll(3),
      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 15)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      hintStyle: WidgetStatePropertyAll(
        appTextTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
      ),
      textStyle: WidgetStatePropertyAll(appTextTheme.bodySmall),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white
    )
  );
}
