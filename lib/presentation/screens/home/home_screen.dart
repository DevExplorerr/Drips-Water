// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:drips_water/presentation/screens/home/cart_screen.dart';
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
    );
  }
}
