import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/total_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const .symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
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
            const SizedBox(height: 10),
            const DeliveryAddressSection(),
            const SizedBox(height: 20),
            const Row(
              children: [
                DeliveryTimeSelectionCard(
                  width: 143,
                  text: 'Standard',
                  time: '10-12 Min',
                  value: 'standard',
                ),
                SizedBox(width: 10),
                DeliveryTimeSelectionCard(
                  width: 210,
                  text: 'Schedule Ahead',
                  time: 'Choose Your Time',
                  value: 'schedule',
                ),
              ],
            ),
            // if (showCalendar)
            const SizedBox(height: 30),
            const CheckoutCalendar(),
            const SizedBox(height: 30),
            Row(
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
            const SizedBox(height: 25),
            const Center(child: CreditCard()),
            const SizedBox(height: 50),
            const TotalSection(),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const .symmetric(horizontal: 15, vertical: 15),
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

bool showCalendar = false;
