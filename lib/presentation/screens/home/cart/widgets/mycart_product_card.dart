import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/model/product_model.dart';
import 'package:flutter/material.dart';

class MyCartProductCard extends StatelessWidget {
  final ProductModel? product;
  const MyCartProductCard({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 85,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage("assets/images/home_screen/slider_image.png"),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    "Drips Spring Water",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    "50ml",
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "\$100",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 15,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Text(
                    "1",
                    style: textTheme.bodySmall?.copyWith(fontFamily: "Inter"),
                  ),
                  const SizedBox(width: 13),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: AppColors.actionButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 15,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
