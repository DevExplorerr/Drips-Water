// ignore_for_file: deprecated_member_use

import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardLoadingIndicator extends StatelessWidget {
  const ProductCardLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = MediaQuery.of(context).size.width < 380
        ? 0.52
        : 0.62;
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey.withOpacity(0.3),
          highlightColor: AppColors.grey.withOpacity(0.1),
          period: const Duration(seconds: 3),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
