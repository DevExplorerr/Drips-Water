// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/auth/login_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoginPromptDialog extends StatelessWidget {
  const CustomLoginPromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: AppColors.black.withOpacity(0.3)),
        ),
        AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          shadowColor: AppColors.black.withOpacity(0.15),
          title: const Icon(
            Icons.lock_outline_rounded,
            size: 48,
            color: AppColors.primary,
          ),
          content: Text(
            "You need to sign in to add products to your favorites.",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: textTheme.bodySmall),
            ),
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              height: 40,
              width: 110,
              text: "Sign In",
            ),
          ],
        ),
      ],
    );
  }
}
