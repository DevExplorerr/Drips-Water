import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/admin_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminOrderTile extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> data;

  const AdminOrderTile({super.key, required this.orderId, required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final addressData = data['address'] as Map? ?? {};
    final customerName = addressData['name'] ?? 'Unknown Customer';
    final items = data['cartItems'] as List? ?? [];
    final status = (data['status'] ?? 'pending').toString().toLowerCase();
    final totalAmount = data['totalAmount'] ?? 0;
    final paymentMethod = data['paymentMethod'] ?? 'COD';

    String formattedDate = "Recently";
    if (data['createdAt'] != null) {
      DateTime dt = (data['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MMM dd, hh:mm a').format(dt);
    }

    return Container(
      margin: const .only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const .symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const .symmetric(horizontal: 16, vertical: 12),
        shape: const RoundedRectangleBorder(side: .none),
        leading: _buildLeadingIcon(addressData['label'] ?? 'Home'),
        title: Text(
          customerName,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: .w700,
            color: AppColors.black,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: textTheme.bodySmall?.copyWith(color: AppColors.grey),
        ),
        trailing: _statusChip(status),

        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),

          _infoRow(
            Icons.confirmation_number_outlined,
            "Order ID",
            "#${orderId.substring(orderId.length - 6)}",
            textTheme,
          ),
          _infoRow(
            Icons.payment_rounded,
            "Payment",
            paymentMethod.toString().toUpperCase(),
            textTheme,
          ),
          _infoRow(
            Icons.location_on_rounded,
            "Deliver to",
            "${addressData['address'] ?? 'No Address'}, ${addressData['city'] ?? ''}",
            textTheme,
          ),

          const SizedBox(height: 20),
          Text(
            "ORDER ITEMS",
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: .w700,
            ),
          ),
          const SizedBox(height: 8),

          if (items.isEmpty)
            const Text(
              "No items found",
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const .symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: .circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${item['quantity'] ?? 1}x ${item['name'] ?? 'Item'}",
                        style: textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      "Rs ${item['selectedPrice'] ?? 0}",
                      style: const TextStyle(fontWeight: .w600),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),
          const Divider(),

          Padding(
            padding: const .symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Grand Total",
                  style: textTheme.bodyLarge?.copyWith(fontWeight: .w700),
                ),
                Text(
                  "Rs $totalAmount",
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w700,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.red,
                  size: 28,
                ),
              ),
              const Spacer(),
              if (status != 'delivered' && status != 'cancelled')
                Expanded(
                  child: CustomButton(
                    height: 50,
                    width: .infinity,
                    buttonColor: status == 'pending'
                        ? AppColors.primary
                        : AppColors.success,
                    text: status == 'pending'
                        ? "Dispatch Now"
                        : "Mark Delivered",
                    fontSize: 14,
                    onPressed: () {
                      String nextStatus = status == 'pending'
                          ? 'dispatched'
                          : 'delivered';

                      context.read<AdminProvider>().updateOrderStatus(
                        orderId,
                        nextStatus,
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const .symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.grey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: textTheme.bodySmall?.copyWith(fontWeight: .w500),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
              overflow: .ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(String label) {
    return Container(
      padding: const .all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: .circle,
      ),
      child: Icon(
        label.toLowerCase() == 'home' ? Icons.home_filled : Icons.work,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == 'pending'
        ? Colors.orange
        : (status == 'dispatched'
              ? AppColors.primary
              : (status == 'cancelled' ? AppColors.red : AppColors.success));
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(20),
        border: .all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: .w700),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationAlertDialog(
        title: "Cancel Order",
        desc: "Are you sure you want to permanently remove this order?",
        icon: Icons.warning_amber_rounded,
        buttonTxt: "Remove Order",
        onConfirm: () async {
          await context.read<AdminProvider>().deleteOrder(orderId);
          if (context.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }
}
