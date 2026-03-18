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

    final status = data['status'] ?? 'pending';
    final items = data['items'] as List? ?? [];
    final addressData = data['address'] as Map? ?? {};
    final customerName = data['userName'] ?? data['name'] ?? 'Unknown Customer';
    final totalAmount = data['totalAmount'] ?? 0;
    final paymentMethod = data['paymentMethod'] ?? 'COD';

    String formattedDate = "Recently";
    if (data['createdAt'] != null) {
      DateTime dt = (data['createdAt'] as dynamic).toDate();
      formattedDate = DateFormat('MMM dd, hh:mm a').format(dt);
    }

    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        shape: const Border(),
        title: Row(
          children: [
            _buildLeadingIcon(addressData['label'] ?? 'Home'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: _statusChip(status),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                // Order Summary
                _infoRow(
                  Icons.receipt_long_outlined,
                  "Order ID",
                  "#${orderId.substring(0, 8)}",
                ),
                _infoRow(
                  Icons.payment_outlined,
                  "Payment",
                  paymentMethod.toString().toUpperCase(),
                ),
                _infoRow(
                  Icons.location_on_outlined,
                  "Deliver to",
                  "${addressData['address']}, ${addressData['district']}",
                ),

                const SizedBox(height: 15),
                Text(
                  "ITEMS",
                  style: textTheme.labelLarge?.copyWith(
                    letterSpacing: 1,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),

                // Dynamic Items List
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item['quantity']}x ${item['productName']}",
                          style: textTheme.bodyMedium,
                        ),
                        Text("₨ ${item['price'] * item['quantity']}"),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 30),

                // Total and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Grand Total",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₨ $totalAmount",
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildActionButtons(context, status),
              ],
            ),
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
    bool isHome = label.toLowerCase() == 'home';
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isHome ? Icons.home_filled : Icons.work,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status) {
    final adminProvider = context.read<AdminProvider>();

    return Row(
      children: [
        // Delete/Cancel Button
        IconButton(
          onPressed: () => _showDeleteDialog(context),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
        const Spacer(),
        // Main Action Button
        if (status != 'delivered')
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'pending' ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              String nextStatus = status == 'pending'
                  ? 'dispatched'
                  : 'delivered';
              adminProvider.updateOrderStatus(orderId, nextStatus);
            },
            child: Text(
              status == 'pending' ? "Dispatch Now" : "Complete Delivery",
            ),
          ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationAlertDialog(
        title: "Cancel Order",
        desc:
            "Are you sure you want to permanently remove this order? This cannot be undone.",
        icon: Icons.warning_amber_rounded,
        buttonTxt: "Remove Order",
        onConfirm: () async {
          await context.read<AdminProvider>().deleteOrder(orderId);
          if (context.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == 'pending'
        ? Colors.orange
        : (status == 'dispatched' ? Colors.blue : Colors.green);
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
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
