// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  int currentSelectedIndex;
  Function(int) updateCurrentIndex;
  BottomNavbar({
    super.key,
    required this.currentSelectedIndex,
    required this.updateCurrentIndex,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final List<IconData> _icons = const [
    Icons.home_outlined,
    Icons.favorite_border_outlined,
    Icons.shopping_cart_outlined,
    Icons.person_outline_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_icons.length, (index) {
            final isSelected = widget.currentSelectedIndex == index;
            return GestureDetector(
              onTap: () {
                widget.updateCurrentIndex(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[index],
                    size: 28,
                    color: isSelected ? AppColors.black : AppColors.grey,
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
