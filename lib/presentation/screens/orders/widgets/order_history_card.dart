import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  const OrderHistoryCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const .only(bottom: 15),
        padding: const .all(15),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: .circular(12),
          border: .all(color: AppColors.grey.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      order.id,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(order.createdAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const Padding(padding: .symmetric(vertical: 12), child: Divider()),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("${order.items.length} Items", style: textTheme.bodySmall),
                Text(
                  "\$${order.totalAmount.toStringAsFixed(2)}",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
        color = AppColors.success;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = AppColors.red;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: .w700),
      ),
    );
  }
}
