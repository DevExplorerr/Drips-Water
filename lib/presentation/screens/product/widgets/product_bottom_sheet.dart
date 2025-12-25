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
  final ProductAction action;
  const ProductBottomSheet({
    super.key,
    required this.product,
    required this.action,
  });

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  int quantity = 1;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.sizes.isNotEmpty
        ? widget.product.sizes.first
        : null;
  }

  int get selectedPrice {
    if (selectedSize == null) return 0;
    return widget.product.pricePerSize[selectedSize!]!;
  }

  String get buttonLabel {
    switch (widget.action) {
      case ProductAction.buyNow:
        return "Buy Now";
      case ProductAction.addToCart:
        return "Add To Cart";
    }
  }

  Future<void> handleProductAction({
    required BuildContext context,
    required ProductAction action,
    required ProductModel product,
    required String size,
    required int quantity,
  }) async {
    if (action == ProductAction.addToCart) {
      final response = await context.read<CartProvider>().addToCart(
        product,
        size,
        quantity,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      if (response.status == CartStatus.success ||
          response.status == CartStatus.error) {
        showFloatingSnackBar(
          context,
          message: response.message,
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.primary,
        );
      }

      if (response.status == CartStatus.guestBlocked) {
        showDialog(
          context: context,
          animationStyle: AnimationStyle(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 200),
          ),
          builder: (_) => CustomLoginPromptDialog(message: response.message),
        );
      }
    }

    if (action == ProductAction.buyNow) {
      Navigator.pop(context);
      await Future.microtask(() {});
      if (!context.mounted) return;
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const CheckoutScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdding = context.select<CartProvider, bool>(
      (cart) => cart.isAdding,
    );

    return SizedBox(
      height: 450,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const .only(left: 15.0, top: 15),
                child: ClipRRect(
                  borderRadius: .circular(20.0),
                  child: CachedNetworkImage(
                    width: 90,
                    height: 90,
                    fit: .cover,
                    imageUrl: widget.product.imageUrl,
                    filterQuality: .high,
                    colorBlendMode: .darken,
                    placeholder: (context, url) => Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primary,
                        size: 50,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: AppColors.icon,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const .only(top: 15),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      "\$${selectedPrice * quantity}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedSize.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: .w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 25),
          Padding(
            padding: const .symmetric(horizontal: 15),
            child: ProductOptionSection(
              product: widget.product,
              quantity: quantity,
              selectedSize: selectedSize ?? "",
              onQuantityChanged: (newQty) {
                setState(() => quantity = newQty);
              },
              onSizeChanged: (size) {
                setState(() => selectedSize = size);
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const .symmetric(horizontal: 15, vertical: 20),
            child: isAdding
                ? LoadingAnimationWidget.threeRotatingDots(
                    color: theme.primaryColor,
                    size: 40,
                  )
                : CustomButton(
                    height: 50,
                    width: .infinity,
                    text: buttonLabel,
                    onPressed: () async {
                      if (selectedSize == null) {
                        showFloatingSnackBar(
                          context,
                          message: "Please select a size",
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                        );
                        return;
                      }

                      handleProductAction(
                        context: context,
                        action: widget.action,
                        product: widget.product,
                        size: selectedSize ?? "",
                        quantity: quantity,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
