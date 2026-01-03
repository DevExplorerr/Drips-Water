import 'package:drips_water/core/enums/commerce_enums.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_sheet_action_buttons.dart';
import 'package:drips_water/presentation/screens/product/bottom_sheets/product_bottom_sheet/product_sheet_header.dart';
import 'package:drips_water/presentation/screens/product/controllers/product_bottom_sheet_controller.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductBottomSheetController(
        product: product,
        initialSize: initialSize,
        initialQuantity: initialQuantity,
        onSizeChanged: onSizeChanged,
      ),
      child: Consumer<ProductBottomSheetController>(
        builder: (context, controller, _) {
          final isAdding = context.select<CartProvider, bool>(
            (cart) => cart.isAdding,
          );
          return SafeArea(
            child: Column(
              mainAxisSize: .min,
              children: [
                ProductSheetHeader(
                  imageUrl: controller.product.imageUrl,
                  price: controller.selectedPrice,
                  selectedSize: controller.selectedSize,
                ),

                const SizedBox(height: 15),
                const Divider(),

                Padding(
                  padding: const .only(left: 15, right: 25, top: 20),
                  child: ProductOptionSection(
                    product: product,
                    quantity: controller.quantity,
                    selectedSize: controller.selectedSize,
                    onQuantityChanged: controller.updateQuantity,
                    onSizeChanged: controller.updateSize,
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const .symmetric(horizontal: 15, vertical: 20),
                  child: ProductSheetActionButtons(
                    action: action,
                    isLoading: isAdding,
                    onAddToCart: () => controller.handleAddToCart(context),
                    onBuyNow: () => controller.handleBuyNow(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
