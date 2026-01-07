import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/product/controllers/product_controller.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_bottom_sheet.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_silver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;
  final String? heroTag;

  const ProductScreen({super.key, this.heroTag, required this.product});

  void _openBottomSheet(BuildContext context, ProductAction action) {
    final controller = context.read<ProductController>();
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ProductBottomSheet(
          product: product,
          initialSize: controller.selectedSize,
          initialQuantity: controller.quantity,
          action: action,
          onSizeChanged: controller.changeSize,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductController(product),
      child: Consumer<ProductController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ProductSilverAppBar(product: product, heroTag: heroTag),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  sliver: SliverToBoxAdapter(
                    child: ProductInfoSection(
                      product: product,
                      price: controller.selectedPrice,
                      selectedSize: controller.selectedSize,
                      onSizeTap: () =>
                          _openBottomSheet(context, ProductAction.all),
                      onSizeChanged: controller.changeSize,
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: ProductBottomNavbar(
              onBuyNowPressed: () =>
                  _openBottomSheet(context, ProductAction.buyNow),
              onAddToCartPressed: () =>
                  _openBottomSheet(context, ProductAction.addToCart),
            ),
          );
        },
      ),
    );
  }
}
