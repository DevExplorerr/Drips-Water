// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/product/product_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/favorite_button.dart';
import 'package:drips_water/presentation/widgets/common/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoriteCard extends StatefulWidget {
  final ProductModel product;
  const FavoriteCard({super.key, required this.product});

  @override
  State<FavoriteCard> createState() => FavoriteCardState();
}

class FavoriteCardState extends State<FavoriteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productData = widget.product;
    final String heroTag = '${productData.id}_FavoriteCard';

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductScreen(product: productData, heroTag: heroTag),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(2, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: heroTag,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: productData.imageUrl,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                colorBlendMode: BlendMode.darken,
                                color: AppColors.black.withOpacity(0.05),
                                placeholder: (_, __) =>
                                    LoadingAnimationWidget.threeArchedCircle(
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.broken_image,
                                  color: AppColors.icon,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: FavoriteButton(
                              productId: productData.id,
                              iconSize: 18,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${productData.price}",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: .w700,
                                ),
                              ),
                              AppBadge(
                                text: "🤍 Favorite",
                                padding: const .symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                borderRadius: .circular(12),
                                color: AppColors.primary.withOpacity(0.7),
                                textStyle: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                  fontWeight: .w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
