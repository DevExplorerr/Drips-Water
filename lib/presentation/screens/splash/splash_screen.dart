// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, annotate_overrides

import 'package:drips_water/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5DCCFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen/logo.png',
              width: 157,
              height: 171,
            ),
            const SizedBox(height: 20),
            Text(
              'Drips Water',
              // style: GoogleFonts.poppins(
              //   fontSize: 38,
              //   fontWeight: FontWeight.bold,
              //   color: Color(0xffFFFFFF),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
