import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/orders/order_details_screen.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/data/repositories/order_repository.dart';
import 'widgets/order_history_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<CheckoutProvider>().uid;
    final orderRepo = OrderRepository();

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderRepo.getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 50,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const AppEmptyState(
              title: "No orders yet.",
              description:
                  "Your order history is empty. Start shopping to fill it up!",
              icon: Icons.add_shopping_cart,
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const .all(15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderHistoryCard(
                order: orders[index],
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          OrderDetailsScreen(order: orders[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
