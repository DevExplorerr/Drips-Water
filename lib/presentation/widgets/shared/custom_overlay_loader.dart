import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomOverlayLoader extends StatelessWidget {
  const CustomOverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: AppColors.black.withValues(alpha: 0.3),
        ),
        BackdropFilter(
          filter: .blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: .circle,
              ),
              alignment: .center,
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.primary,
                size: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
