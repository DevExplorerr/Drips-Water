import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_sheet_action_buttons.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_sheet_header.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool _localIsLoading = false;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.initialSize;
    quantity = widget.initialQuantity;
  }

  int get selectedPrice => widget.product.pricePerSize[selectedSize]!;

  void _updateSize(String size) {
    setState(() => selectedSize = size);
    widget.onSizeChanged(size);
  }

  void _updateQuantity(int value) {
    setState(() => quantity = value);
  }

  Future<void> _handleAddToCart() async {
    setState(() => _localIsLoading = true);
    final cartProvider = context.read<CartProvider>();

    final response = await cartProvider.addToCart(
      widget.product,
      selectedSize,
      quantity,
    );

    if (!mounted) return;
    setState(() => _localIsLoading = false);
    Navigator.pop(context);

    if (response.status == CartStatus.success ||
        response.status == CartStatus.error) {
      showFloatingSnackBar(
        context,
        message: response.message,
        duration: const Duration(seconds: 2),
        backgroundColor: response.status == CartStatus.success
            ? AppColors.primary
            : AppColors.error,
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
    final isAdding =
        context.select<CartProvider, bool>((cart) => cart.isAdding) ||
        _localIsLoading;

    return SizedBox(
      height: 460,
      child: Column(
        children: [
          ProductSheetHeader(
            imageUrl: widget.product.imageUrl,
            price: selectedPrice,
            selectedSize: selectedSize,
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
            child: ProductSheetActionButtons(
              action: widget.action,
              isLoading: isAdding,
              onAddToCart: _handleAddToCart,
              onBuyNow: _handleBuyNow,
            ),
          ),
        ],
      ),
    );
  }
}
