import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/data/services/auth_service.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_screen.dart';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductBottomSheetController extends ChangeNotifier {
  final ProductModel product;
  final ValueChanged<String> onSizeChanged;
  late String _selectedSize;
  int _quantity;

  ProductBottomSheetController({
    required this.product,
    required String initialSize,
    required int initialQuantity,
    required this.onSizeChanged,
  }) : _selectedSize = initialSize,
       _quantity = initialQuantity;

  // Getters
  String get selectedSize => _selectedSize;
  int get quantity => _quantity;
  int get selectedPrice => product.pricePerSize[_selectedSize]!;

  void updateSize(String size) {
    _selectedSize = size;
    onSizeChanged.call(size);
    notifyListeners();
  }

  void updateQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  Future<void> handleAddToCart(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();

    final response = await cartProvider.addToCart(
      product,
      selectedSize,
      quantity,
    );

    if (!context.mounted) return;

    if (response.status == CartStatus.guestBlocked) {
      showDialog(
        context: context,
        builder: (_) => CustomLoginPromptDialog(message: response.message),
      );
      return;
    }

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
  }

  void handleBuyNow(BuildContext context) {
    if (AuthService.isGuestUser) {
      showDialog(
        context: context,
        animationStyle: AnimationStyle(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 200),
        ),
        builder: (_) => const CustomLoginPromptDialog(
          message: "Please sign in to proceed with your purchase.",
        ),
      );
      return;
    }

    final buyNowItem = CartItemModel(
      productId: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      selectedSize: selectedSize,
      selectedPrice: selectedPrice,
      quantity: quantity,
    );

    Navigator.pop(context);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CheckoutScreen(buyNowItem: buyNowItem),
      ),
    );
  }
}
