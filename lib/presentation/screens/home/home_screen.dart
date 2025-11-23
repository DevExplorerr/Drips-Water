// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/services/user_service.dart';
import 'package:drips_water/logic/view_models/home/home_app_bar_view_model.dart';
import 'package:drips_water/logic/view_models/product/product_grid_view_model.dart';
import 'package:drips_water/presentation/screens/home/cart_screen.dart';
import 'package:drips_water/presentation/screens/home/chatbot/chatbot_screen.dart';
import 'package:drips_water/presentation/screens/home/favorite/favorite_screen.dart';
import 'package:drips_water/presentation/screens/home/profile_screen.dart';
import 'package:drips_water/presentation/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/home_content/home_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSelectedIndex = 0;

  Future<bool> _onWillPop() async {
    if (_currentSelectedIndex != 0) {
      setState(() => _currentSelectedIndex = 0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              final user = FirebaseAuth.instance.currentUser;
              return HomeAppBarViewModel(UserService())
                ..loadUserName(user?.uid);
            },
          ),
          ChangeNotifierProvider(
            create: (_) => ProductGridViewModel()..loadProducts(),
          ),
        ],
        child: Scaffold(
          body: IndexedStack(
            index: _currentSelectedIndex,
            children: const [
              HomeContent(),
              FavoriteScreen(),
              CartScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavbar(
            currentSelectedIndex: _currentSelectedIndex,
            updateCurrentIndex: (i) =>
                setState(() => _currentSelectedIndex = i),
          ),
          floatingActionButton: const ChatBotFloatingButton(),
        ),
      ),
    );
  }
}

class ChatBotFloatingButton extends StatelessWidget {
  const ChatBotFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
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
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [const BoxShadow(color: AppColors.grey, blurRadius: 5)],
        ),
        child: const Icon(Icons.chat, color: AppColors.white, size: 30),
      ),
    );
  }
}
