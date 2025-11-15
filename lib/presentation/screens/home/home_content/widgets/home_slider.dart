import 'dart:async';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int currentIndex = 0;
  final PageController pageController = PageController();
  Timer? autoSlideTimer;

  final List<Map<String, String>> sliderData = [
    {
      'image': 'assets/images/home_screen/slider_image.png',
      'image1': 'assets/images/home_screen/slider_shade.png',
      'title': 'Drips Springs',
      'description': 'Bottle water delivery',
    },
    {
      'image': 'assets/images/home_screen/slider_image.png',
      'image1': 'assets/images/home_screen/slider_shade.png',
      'title': 'Drips Distilled',
      'description': 'Bottle water delivery',
    },
    {
      'image': 'assets/images/home_screen/slider_image.png',
      'image1': 'assets/images/home_screen/slider_shade.png',
      'title': 'Drips Purified',
      'description': 'Bottle water delivery',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _cancelTimer();
    autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        final nextPage = (currentIndex + 1) % sliderData.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _cancelTimer() {
    autoSlideTimer?.cancel();
    autoSlideTimer = null;
  }

  void _pauseAndResumeAutoSlide() {
    _cancelTimer();
    // Resume after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _cancelTimer();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        GestureDetector(
          onPanDown: (_) => _pauseAndResumeAutoSlide(),
          onPanCancel: _pauseAndResumeAutoSlide,
          onPanEnd: (_) => _pauseAndResumeAutoSlide(),
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: pageController,
              itemCount: sliderData.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (context, index) {
                final item = sliderData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(item['image']!),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(item['image1']!),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['description']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFFC33A),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Quick Shop",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        sliderData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 20 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.secondaryText
                : AppColors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
