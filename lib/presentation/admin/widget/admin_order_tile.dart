import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrderTile extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> data;

  const AdminOrderTile({super.key, required this.orderId, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'pending';
    final items = data['items'] as List? ?? [];
    final address = data['address']?['address'] ?? 'No Address Provided';
    final customerName = data['userName'] ?? 'Customer';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${items.length} items • Total: ₨ ${data['totalAmount']}",
        ),
        trailing: _statusChip(status),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(address),
                const SizedBox(height: 15),
                if (status != 'delivered')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: status == 'pending'
                                ? Colors.blue
                                : Colors.green,
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
                            status == 'pending' ? "Dispatch" : "Mark Delivered",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == 'pending'
        ? Colors.orange
        : (status == 'dispatched' ? Colors.blue : Colors.green);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
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
}
