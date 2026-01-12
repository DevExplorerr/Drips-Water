import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
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

  void handleBuyNow(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CheckoutScreen()),
    );
  }
}
