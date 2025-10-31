// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/home/cart_screen.dart';
import 'package:drips_water/presentation/screens/home/chatbot_screen.dart';
import 'package:drips_water/presentation/screens/home/favorite_screen.dart';
import 'package:drips_water/presentation/screens/home/profile_screen.dart';
import 'package:drips_water/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:drips_water/presentation/widgets/home_content/home_content.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      _currentSelectedIndex = index;
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContent(),
      const FavoriteScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentSelectedIndex, children: _screens),
      bottomNavigationBar: BottomNavbar(
        currentSelectedIndex: _currentSelectedIndex,
        updateCurrentIndex: updateCurrentIndex,
      ),
      floatingActionButton: const ChatBotFloatingButton(),
    );
  }
}

class ChatBotFloatingButton extends StatelessWidget {
  const ChatBotFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatBotScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final fadeAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  );

                  return FadeTransition(opacity: fadeAnimation, child: child);
                },
          ),
        );
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: theme.floatingActionButtonTheme.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [const BoxShadow(color: AppColors.grey, blurRadius: 5)],
        ),
        child: Icon(Icons.chat, color: AppColors.white, size: 30),
      ),
    );
  }
}
