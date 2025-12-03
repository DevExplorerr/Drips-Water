// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/mycart_product_card.dart';
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
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (_, index) {
          final cartItem = cart.cartItems[index];
          return MyCartProductCard(product: cartItem);
        },
      ),

      bottomNavigationBar: const CartBottomNavbar(),
    );
  }
}
