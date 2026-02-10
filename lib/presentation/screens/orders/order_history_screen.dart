import 'package:flutter/material.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderHistoryCard(
                order: orders[index],
                onTap: () {
                  // Navigate to Order Details (We can build this next)
                },
              );
            },
          );
        },
      ),
    );
  }
}
