import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_bottom_sheet.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_info_section.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_silver_app_bar.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ProductSilverAppBar(product: widget.product, heroTag: widget.heroTag),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
            sliver: SliverToBoxAdapter(
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
