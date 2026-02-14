import 'package:flutter/material.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'widgets/tracking_step_item.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Track Order"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const .only(top: 40, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            const TrackingStepItem(
              icon: Icons.receipt_long_outlined,
              title: "Order Placed",
              subtitle: "We have received your order",
              isCompleted: true,
            ),
            TrackingStepItem(
              icon: Icons.inventory_2_outlined,
              title: "Order Packed",
              subtitle: "Your water is being prepared",
              isCompleted: order.status != 'pending',
              isCurrent: order.status == 'packed',
            ),
            TrackingStepItem(
              icon: Icons.local_shipping_outlined,
              title: "On the Way",
              subtitle: "Driver is heading to your location",
              isCompleted: order.status == 'delivered',
              isCurrent: order.status == 'on the way',
            ),
            TrackingStepItem(
              icon: Icons.check_circle_outline,
              title: "Delivered",
              subtitle: "Enjoy your fresh water!",
              isLast: true,
              isCompleted: order.status == 'delivered',
            ),
          ],
        ),
      ),
    );
  }
}
