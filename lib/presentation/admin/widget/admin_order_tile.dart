import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/admin_provider.dart';
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: _buildLeadingIcon(addressData['label'] ?? 'Home'),
        title: Text(
          customerName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        trailing: _statusChip(status),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),

          _infoRow(
            Icons.confirmation_number_outlined,
            "Order ID",
            "#${orderId.substring(orderId.length - 6)}",
          ),
          _infoRow(
            Icons.payment_rounded,
            "Payment",
            paymentMethod.toString().toUpperCase(),
          ),
          _infoRow(
            Icons.location_on_rounded,
            "Deliver to",
            "${addressData['address'] ?? 'No Address'}, ${addressData['city'] ?? ''}",
          ),

          const SizedBox(height: 20),
          Text(
            "ORDER ITEMS",
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          if (items.isEmpty)
            const Text(
              "No items found",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${item['quantity'] ?? 1}x ${item['name'] ?? 'Item'}",
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      "Rs ${item['selectedPrice'] ?? 0}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),
          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs $totalAmount",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const Spacer(),
              if (status != 'delivered' && status != 'cancelled')
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == 'pending'
                          ? Colors.blue
                          : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      String nextStatus = status == 'pending'
                          ? 'dispatched'
                          : 'delivered';
                      context.read<AdminProvider>().updateOrderStatus(
                        orderId,
                        nextStatus,
                      );
                    },
                    child: Text(
                      status == 'pending' ? "Dispatch Now" : "Mark Delivered",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
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
              ? Colors.blue
              : (status == 'cancelled' ? Colors.red : Colors.green));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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
