// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/welcome/welcome_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onBoardingData = [
    {
      'image': 'assets/images/onboarding_images/onboarding_image1.png',
      'title': 'We provide best quality water',
    },
    {
      'image': 'assets/images/onboarding_images/onboarding_image2.png',
      'title': 'Schedule when you want your water delivered',
    },
    {
      'image': 'assets/images/onboarding_images/onboarding_image3.png',
      'title': 'Fast and responsibility delivery',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToNextPage() {
    if (currentIndex < onBoardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void navigateToWelcomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onBoardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onBoardingData[index]['image']!,
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          onBoardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: textTheme.titleLarge?.copyWith(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _pageIndicator(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _bottomButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _pageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onBoardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 20 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primary
                : AppColors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
      child: CustomButton(
        height: 65,
        width: double.infinity,
        text: currentIndex < onBoardingData.length - 1 ? 'NEXT' : 'GET STARTED',
        onPressed: currentIndex < onBoardingData.length - 1
            ? navigateToNextPage
            : navigateToWelcomePage,
      ),
    );
  }
}
