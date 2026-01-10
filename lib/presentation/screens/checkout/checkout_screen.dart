import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/total_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

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
                    width: 210,
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
