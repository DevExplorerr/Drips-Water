import 'dart:ui';

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CartScreenLoader extends StatelessWidget {
  const CartScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.3),
        alignment: Alignment.center,
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: LoadingAnimationWidget.threeArchedCircle(
            color: AppColors.primary,
            size: 50,
          ),
        ),
      ),
    );
  }
}
