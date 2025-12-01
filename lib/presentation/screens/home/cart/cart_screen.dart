// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
import 'package:drips_water/data/model/product_model.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/cart_bottom_navbar.dart';
import 'package:drips_water/presentation/screens/home/cart/widgets/mycart_product_card.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final ProductModel? product;
  const CartScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(centerTitle: true, title: const Text("My Cart")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: MyCartProductCard(product: product),
      ),

      bottomNavigationBar: const CartBottomNavbar(),
    );
  }
}
