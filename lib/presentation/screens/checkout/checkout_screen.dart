import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/total_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String defaultDeliveryOption = "standard";
  bool get showCalendar => defaultDeliveryOption == 'schedule';

  void _onOptionSelected(String value) {
    setState(() {
      defaultDeliveryOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const .symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Order Summary",
                    style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final product = ProductModel(
                        id: cartItem.productId,
                        name: cartItem.name,
                        imageUrl: cartItem.imageUrl,
                        category: '',
                        description: '',
                        sizes: [cartItem.selectedSize],
                        pricePerSize: {
                          cartItem.selectedSize: cartItem.selectedPrice,
                        },
                        rating: 0,
                        reviews: 0,
                        stock: 0,
                      );

                      return CheckoutProductCard(
                        image: cartItem.imageUrl,
                        productName: cartItem.name,
                        selectedPrice: cartItem.selectedPrice,
                        quantity: cartItem.quantity,
                        selectedSize: cartItem.selectedSize,
                        onIncrement: () {
                          context.read<CartProvider>().addToCart(
                            product,
                            cartItem.selectedSize,
                            1,
                          );
                        },
                        onDecrement: () {
                          context.read<CartProvider>().decrease(
                            cartItem.productId,
                            cartItem.selectedSize,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const .symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "Delivery Address",
                    style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                  ),
                  TextButton(
                    style: theme.textButtonTheme.style,
                    onPressed: () {},
                    child: Text(
                      "Change",
                      style: textTheme.bodySmall?.copyWith(fontWeight: .w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: .symmetric(horizontal: 15),
              child: DeliveryAddressSection(),
            ),
            const SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 15),
              child: Row(
                children: [
                  DeliveryTimeSelectionCard(
                    width: 143,
                    text: 'Standard',
                    time: '20-30 Min',
                    value: 'standard',
                    isSelected: defaultDeliveryOption == 'standard',
                    onTap: () => _onOptionSelected("standard"),
                  ),
                  const SizedBox(width: 10),
                  DeliveryTimeSelectionCard(
                    width: 190,
                    text: 'Schedule Ahead',
                    time: 'Choose Your Time',
                    value: 'schedule',
                    isSelected: defaultDeliveryOption == 'schedule',
                    onTap: () => _onOptionSelected("schedule"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            if (showCalendar)
              const Padding(
                padding: .symmetric(horizontal: 15),
                child: CheckoutCalendar(),
              ),
            const SizedBox(height: 25),
            Padding(
              padding: .symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "Payment",
                    style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: AppColors.icon, size: 15),
                        const SizedBox(width: 5),
                        Text(
                          "Add New Card",
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Center(child: CreditCard()),
            const SizedBox(height: 50),
            const Padding(
              padding: .only(left: 15, right: 15, bottom: 15),
              child: TotalSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const .all(15),
        height: 80,
        color: Colors.transparent,
        elevation: 0,
        child: CustomButton(
          height: 50,
          width: .infinity,
          text: "Place Order",
          onPressed: () {},
        ),
      ),
    );
  }
}
