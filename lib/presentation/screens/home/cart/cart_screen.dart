// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/mycart_product_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(centerTitle: true, title: const Text("My Cart")),
      body: cart.cartItems.isEmpty
          ? const AppEmptyState(
              title: "Cart is empty",
              description: "Add item to cart",
              icon: Icons.shopping_cart_outlined,
            )
          : ListView.builder(
              itemCount: cart.cartItems.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                final cartItem = cart.cartItems[index];
                return MyCartProductCard(product: cartItem);
              },
            ),

      bottomNavigationBar: const CartBottomNavbar(),
    );
  }
}
