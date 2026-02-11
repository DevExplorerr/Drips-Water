// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_product_card.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/custom_overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationAlertDialog(
        title: "Clear Cart?",
        icon: Icons.delete_forever_rounded,
        desc: "Do you really want to remove all items?",
        buttonTxt: "Clear",
        successMessage: "Cart cleared successfully",
        onConfirm: () async {
          await context.read<CartProvider>().clearCart();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: const Text("My Cart"),
            actions: [
              if (cart.cartItems.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _showClearDialog(context);
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          body: cart.cartItems.isEmpty
              ? const AppEmptyState(
                  title: "Cart is empty",
                  description: "Add item to cart",
                  icon: Icons.shopping_cart_outlined,
                )
              : Stack(
                  children: [
                    ListView.builder(
                      itemCount: cart.cartItems.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (_, index) {
                        final cartItem = cart.cartItems[index];
                        return CartProductCard(product: cartItem);
                      },
                    ),
                  ],
                ),

          bottomNavigationBar: const CartBottomNavbar(),
        ),
        if (cart.isUpdatingQty)
          const Positioned.fill(child: CustomOverlayLoader()),
      ],
    );
  }
}
