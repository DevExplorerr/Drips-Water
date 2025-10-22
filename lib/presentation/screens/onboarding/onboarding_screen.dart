// ignore_for_file: depend_on_referenced_packages

import 'package:drips_water/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    },
    {
      'image': 'assets/images/onboarding_images/onboarding_image2.png',
      'title': 'Schedule when you want your water delivered',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    },
    {
      'image': 'assets/images/onboarding_images/onboarding_image3.png',
      'title': 'Fast and responsibility delivery',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (currentIndex < onBoardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void goToWelcomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
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
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.35,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          onBoardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          // style: GoogleFonts.inter(
                          //   color: const Color(0xff625D5D),
                          //   fontSize: screenWidth * 0.06,
                          //   fontWeight: FontWeight.w700,
                          // ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          onBoardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          // style: GoogleFonts.inter(
                          //   color: const Color(0xff625D5D),
                          //   fontSize: screenWidth * 0.042,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _buildPageIndicator(),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildBottomButton(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
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
                ? const Color(0xff5DCCFC)
                : Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(double screenWidth, double screenHeight) {
    return ElevatedButton(
      onPressed: currentIndex < onBoardingData.length - 1
          ? goToNextPage
          : goToWelcomePage,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff5DCCFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.015),
        ),
        minimumSize: Size(double.infinity, screenHeight * 0.08),
      ),
      child: Text(
        currentIndex < onBoardingData.length - 1 ? 'NEXT' : 'GET STARTED',
        // style: GoogleFonts.poppins(
        //   color: Colors.white,
        //   fontSize: screenWidth * 0.045,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }
}
