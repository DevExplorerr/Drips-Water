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
  final OrderRepository _orderRepo = OrderRepository();

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
    final String uid = context.read<CheckoutProvider>().uid;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: Column(
        children: [
          _buildFilterBar(),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<List<OrderModel>>(
              stream: _orderRepo.getUserOrders(
                uid,
                statusFilter: _selectedFilter,
              ),
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
                  padding: const .fromLTRB(15, 5, 15, 15),
                  itemCount: orders.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderHistoryCard(
                      key: ValueKey(order.id),
                      order: order,
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => OrderDetailsScreen(order: order),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      width: .infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: .horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const .symmetric(horizontal: 15, vertical: 10),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return _FilterChip(
            label: filter,
            isSelected: isSelected,
            onTap: () {
              if (_selectedFilter != filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const .symmetric(horizontal: 20),
          alignment: .center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.card,
            borderRadius: .circular(25),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? AppColors.white : AppColors.secondaryText,
              fontWeight: isSelected ? .w700 : .normal,
            ),
          ),
        ),
      ),
    );
  }
}
