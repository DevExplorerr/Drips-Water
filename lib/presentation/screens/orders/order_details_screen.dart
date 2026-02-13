import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/presentation/screens/orders/widgets/order_item_tile.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Order Details"), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const .all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Order Status & ID Card
            _buildSectionCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Order ID",
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.id,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusBadge(order.status),
                    ],
                  ),
                  const Padding(
                    padding: .symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.icon,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'MMMM dd, yyyy • hh:mm a',
                        ).format(order.createdAt),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _sectionHeader("Purchased Items", textTheme),

            // 2. Items List
            _buildSectionCard(
              child: Column(
                children: order.items
                    .map((item) => OrderItemTile(item: item))
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),
            _sectionHeader("Delivery Details", textTheme),

            // 3. Address & Time Card
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        order.address.name,
                        style: textTheme.bodyLarge?.copyWith(fontWeight: .w700),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const .only(left: 34, top: 4),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(order.address.phone, style: textTheme.bodyMedium),
                        Text(
                          "${order.address.address}, ${order.address.district}, ${order.address.city}",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.scheduledTime != null) ...[
                    const Divider(height: 32),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Scheduled Delivery",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('hh:mm a').format(order.scheduledTime!),
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),
            _sectionHeader("Payment Summary", textTheme),

            // 4. Price Breakdown Card
            _buildSectionCard(
              child: Column(
                children: [
                  _priceRow("Subtotal", order.subtotal, textTheme),
                  _priceRow("Delivery Fee", order.deliveryFee, textTheme),
                  if (order.discount > 0)
                    _priceRow(
                      "Discount",
                      -order.discount,
                      textTheme,
                      isDiscount: true,
                    ),
                  const Padding(
                    padding: .symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      Text(
                        "\$${order.totalAmount.toStringAsFixed(2)}",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: .w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: .infinity,
                    padding: const .symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.05),
                      borderRadius: .circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Paid via ${order.paymentMethod.toUpperCase()}",
                        style: textTheme.labelLarge?.copyWith(
                          fontStyle: .italic,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Helper UI Builders ---

  Widget _sectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const .only(left: 4, bottom: 12),
      child: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: .infinity,
      padding: const .all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _priceRow(
    String label,
    double price,
    TextTheme textTheme, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const .symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Text(
            "${isDiscount ? '-' : ''}\$${price.abs().toStringAsFixed(2)}",
            style: textTheme.bodyMedium?.copyWith(
              color: isDiscount ? AppColors.success : AppColors.textLight,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: .circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: .w700,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
