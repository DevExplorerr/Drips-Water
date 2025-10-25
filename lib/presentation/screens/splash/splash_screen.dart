// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, annotate_overrides

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:drips_water/presentation/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (seenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } else {
      await prefs.setBool('seenOnboarding', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen/logo.png',
              width: 160,
              height: 170,
              filterQuality: FilterQuality.high,
            ),

            const SizedBox(height: 20),
            const Text(
              'Drips Water',
              style: TextStyle(
                fontSize: 40,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 40),
            LoadingAnimationWidget.fourRotatingDots(
              color: AppColors.white,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
