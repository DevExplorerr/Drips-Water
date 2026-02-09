import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const .symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                'assets/images/order_success/box.png',
                height: 200,
                filterQuality: .high,
              ),
              const SizedBox(height: 40),
              Text(
                "Order Successful!",
                style: textTheme.bodyLarge?.copyWith(fontWeight: .w700),
              ),
              const SizedBox(height: 15),
              Text(
                "Your order #$orderId has been placed successfully. We'll notify you once your water is on the way!",
                textAlign: .center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                height: 55,
                width: .infinity,
                text: "Continue Shopping",
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => OrderTrackingPage()));
                },
                child: Text(
                  "Track Order",
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
