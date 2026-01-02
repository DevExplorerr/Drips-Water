import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProductBottomSheet extends StatefulWidget {
  final ProductModel product;
  final String initialSize;
  final int initialQuantity;
  final ProductAction action;
  final ValueChanged<String> onSizeChanged;

  const ProductBottomSheet({
    super.key,
    required this.product,
    required this.initialSize,
    required this.initialQuantity,
    required this.action,
    required this.onSizeChanged,
  });

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  late String selectedSize;
  late int quantity;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.initialSize;
    quantity = widget.initialQuantity;
  }

  int get selectedPrice => widget.product.pricePerSize[selectedSize]!;

  void _updateSize(String size) {
    setState(() {
      selectedSize = size;
    });
    widget.onSizeChanged(size);
  }

  void _updateQuantity(int value) {
    setState(() {
      quantity = value;
    });
  }

  Future<void> _handleAddToCart() async {
    final cartProvider = context.read<CartProvider>();

    final response = await cartProvider.addToCart(
      widget.product,
      selectedSize,
      quantity,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (response.status == CartStatus.success ||
        response.status == CartStatus.error) {
      showFloatingSnackBar(
        context,
        message: response.message,
        duration: const Duration(seconds: 2),
        backgroundColor: response.status == CartStatus.success
            ? AppColors.primary
            : Colors.red,
      );
    }

    if (response.status == CartStatus.guestBlocked) {
      showDialog(
        context: context,
        builder: (_) => CustomLoginPromptDialog(message: response.message),
      );
    }
  }

  void _handleBuyNow() {
    Navigator.pop(context);

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showAddToCart =
        widget.action == ProductAction.addToCart ||
        widget.action == ProductAction.all;
    final showBuyNow =
        widget.action == ProductAction.buyNow ||
        widget.action == ProductAction.all;

    final isAdding = context.select<CartProvider, bool>(
      (cart) => cart.isAdding,
    );

    return SizedBox(
      height: 460,
      child: Column(
        children: [
          Padding(
            padding: const .only(left: 15.0, top: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: .circular(20.0),
                  child: CachedNetworkImage(
                    width: 90,
                    height: 90,
                    fit: .cover,
                    filterQuality: .high,
                    imageUrl: widget.product.imageUrl,
                    placeholder: (context, url) => Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: AppColors.icon,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "\$$selectedPrice",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: .w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedSize,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
          const Divider(),

          Padding(
            padding: const .only(left: 15, right: 25, top: 15),
            child: ProductOptionSection(
              product: widget.product,
              quantity: quantity,
              selectedSize: selectedSize,
              onQuantityChanged: _updateQuantity,
              onSizeChanged: _updateSize,
            ),
          ),

          const Spacer(),

          Padding(
            padding: const .symmetric(horizontal: 15, vertical: 20),
            child: isAdding
                ? Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 40,
                    ),
                  )
                : Row(
                    children: [
                      if (showAddToCart)
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            width: double.infinity,
                            color: AppColors.primary,
                            text: "Add to Cart",
                            onPressed: _handleAddToCart,
                          ),
                        ),
                      if (showAddToCart && showBuyNow)
                        const SizedBox(width: 10),

                      if (showBuyNow)
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            width: double.infinity,
                            color: AppColors.primary,
                            text: "Buy Now",
                            onPressed: _handleBuyNow,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
