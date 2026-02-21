import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/data/repositories/order_repository.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/screens/orders/order_details_screen.dart';
import 'package:drips_water/presentation/screens/orders/widgets/order_history_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<String> _filters = [
    'All',
    'Pending',
    'On the Way',
    'Delivered',
    'Cancelled',
  ];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildOrderList()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      width: double.infinity,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.secondaryText,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList() {
    final orderRepo = OrderRepository();
    final String uid = context.read<CheckoutProvider>().uid;
    return StreamBuilder<List<OrderModel>>(
      stream: orderRepo.getUserOrders(uid, statusFilter: _selectedFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.primary,
              size: 40,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return AppEmptyState(
            title: "No orders found",
            description: "No $_selectedFilter orders found",
            icon: Icons.history_rounded,
          );
        }

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
                    builder: (_) => OrderDetailsScreen(order: orders[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
