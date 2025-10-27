import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String image;
  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProductPage()));
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.favorite,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              productName,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              price,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
