import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_bottom_sheet.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_image_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/widgets/icon_badge/cart_icon_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  final String? heroTag;

  const ProductScreen({super.key, this.heroTag, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String selectedSize;
  late int selectedPrice;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.sizes.first;
    selectedPrice = widget.product.pricePerSize[selectedSize]!;
  }

  void onSizeChanged(String size) {
    setState(() {
      selectedSize = size;
      selectedPrice = widget.product.pricePerSize[size]!;
    });
  }

  void _openBottomSheet(ProductAction action) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ProductBottomSheet(
          product: widget.product,
          initialSize: selectedSize,
          initialQuantity: quantity,
          action: action,
          onSizeChanged: onSizeChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.35;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            expandedHeight: imageHeight,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: Padding(
              padding: const .only(left: 15, top: 6, bottom: 6),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.5),
                    borderRadius: .circular(6),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primary),
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const .only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const CheckoutScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.5),
                      borderRadius: .circular(6),
                    ),
                    child: const Center(
                      child: CartIconBadge(
                        icon: Icons.shopping_bag_outlined,
                        iconColor: AppColors.primary,
                        badgeColor: AppColors.primary,
                        textColor: AppColors.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ProductImageSection(
                productId: widget.product.id,
                image: widget.product.imageUrl,
                heroTag: widget.heroTag ?? "",
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const .only(left: 15, right: 15, top: 20, bottom: 50),
              child: ProductInfoSection(
                product: widget.product,
                price: selectedPrice,
                selectedSize: selectedSize,
                onSizeTap: () => _openBottomSheet(ProductAction.all),
                onSizeChanged: onSizeChanged,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductBottomNavbar(
        onBuyNowPressed: () => _openBottomSheet(ProductAction.buyNow),
        onAddToCartPressed: () => _openBottomSheet(ProductAction.addToCart),
      ),
    );
  }
}
