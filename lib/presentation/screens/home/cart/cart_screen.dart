// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_product_card.dart';
import 'package:drips_water/presentation/widgets/dialog/confirm_clear_cart_dialog.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmClearCartDialog(
        onConfirm: () async {
          await context.read<CartProvider>().clearCart();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
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
          : ListView.builder(
              itemCount: cart.cartItems.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 15),
              itemBuilder: (_, index) {
                final cartItem = cart.cartItems[index];
                return CartProductCard(product: cartItem);
              },
            ),

      bottomNavigationBar: const CartBottomNavbar(),
    );
  }
}
