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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details", style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: ID and Date ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID", style: textTheme.bodySmall),
                    Text(
                      order.id,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('MMMM dd, yyyy • hh:mm a').format(order.createdAt),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const Divider(height: 40),

            // --- Section: Items ---
            Text(
              "Items",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: order.items
                  .map((item) => OrderItemTile(item: item))
                  .toList(),
            ),
            const Divider(height: 40),

            // --- Section: Delivery Address ---
            Text(
              "Delivery Address",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              order.address.name,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(order.address.phone, style: textTheme.bodySmall),
            Text(
              "${order.address.address}, ${order.address.district}, ${order.address.city}",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const Divider(height: 40),

            // --- Section: Payment Summary ---
            Text(
              "Payment Summary",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildPriceRow("Subtotal", order.subtotal, textTheme),
            _buildPriceRow("Delivery Fee", order.deliveryFee, textTheme),
            if (order.discount > 0)
              _buildPriceRow(
                "Discount",
                -order.discount,
                textTheme,
                isDiscount: true,
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${order.totalAmount.toStringAsFixed(2)}",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Paid via ${order.paymentMethod.toUpperCase()}",
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double price,
    TextTheme textTheme, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Text(
            "${isDiscount ? '-' : ''}\$${price.abs().toStringAsFixed(2)}",
            style: textTheme.bodySmall?.copyWith(
              color: isDiscount ? Colors.green : AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
