import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/header_icon.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/widgets/icon_badge/cart_icon_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductSilverAppBar extends StatelessWidget {
  final ProductModel product;
  final String? heroTag;
  const ProductSilverAppBar({super.key, required this.product, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.35;
    return SliverAppBar(
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      expandedHeight: imageHeight,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const .only(left: 15, top: 6, bottom: 6),
        child: HeaderIcon(
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back,
        ),
      ),

      actions: [
        Padding(
          padding: const .only(right: 15.0),
          child: HeaderIcon(
            child: const CartIconBadge(
              icon: Icons.shopping_bag_outlined,
              iconColor: AppColors.primary,
              badgeColor: AppColors.primary,
              textColor: AppColors.white,
              width: 25,
              height: 25,
            ),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const CheckoutScreen()),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ProductImageSection(
          productId: product.id,
          image: product.imageUrl,
          heroTag: heroTag ?? "",
        ),
      ),
    );
  }
}
