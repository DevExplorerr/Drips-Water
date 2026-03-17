import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/services/admin_service.dart';
import 'package:drips_water/presentation/admin/widget/admin_order_tile.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = context.read<AdminService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: StreamBuilder<QuerySnapshot>(
        stream: adminService.getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 40,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const AppEmptyState(
              title: "No Order Found",
              description: "There are no orders to display at this time",
              icon: Icons.shopping_bag_outlined,
            );
          }

          final docs = snapshot.data!.docs;

          int pending = 0;
          int onWay = 0;
          int delivered = 0;
          double revenue = 0;

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status']?.toString().toLowerCase() ?? '';
            final amount = (data['totalAmount'] ?? 0).toDouble();

            if (status == 'pending') pending++;
            if (status == 'dispatched') onWay++;
            if (status == 'delivered') {
              delivered++;
              revenue += amount;
            }
          }

          return SingleChildScrollView(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                _buildStatGrid(pending, onWay, delivered, revenue),
                const SizedBox(height: 25),
                Text(
                  "Recent Orders",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return AdminOrderTile(orderId: docs[index].id, data: data);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatGrid(int p, int w, int d, double r) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _statCard(
          "Pending",
          p.toString(),
          Icons.hourglass_empty,
          Colors.orange,
        ),
        _statCard(
          "On The Way",
          w.toString(),
          Icons.local_shipping,
          Colors.blue,
        ),
        _statCard(
          "Delivered",
          d.toString(),
          Icons.check_circle,
          AppColors.success,
        ),
        _statCard(
          "Revenue",
          "₨ ${r.toStringAsFixed(0)}",
          Icons.payments,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const .all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: .circular(15),
        border: .all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: .bold)),
          Text(
            title,
            style: const TextStyle(color: AppColors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
