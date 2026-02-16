import 'package:drips_water/logic/providers/order_provider.dart';
import 'package:drips_water/presentation/screens/orders/order_tracking_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/order_model.dart';
import 'package:drips_water/presentation/screens/orders/widgets/order_item_tile.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Order Details"), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const .all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _OrderHeaderCard(order: order),
            const SizedBox(height: 24),
            _sectionHeader("Purchased Items", textTheme),
            _OrderItemsCard(order: order),
            const SizedBox(height: 24),
            _sectionHeader("Delivery Details", textTheme),
            _DeliveryDetailsCard(order: order),
            const SizedBox(height: 24),
            _sectionHeader("Payment Summary", textTheme),
            _PaymentSummaryCard(order: order),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const .only(left: 4, bottom: 12),
      child: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderHeaderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final orderId =
        (context.findAncestorWidgetOfExactType<OrderDetailsScreen>())!.order.id;
    final textTheme = Theme.of(context).textTheme;
    return _BaseSectionCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Order ID",
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.id,
                      style: textTheme.titleSmall?.copyWith(fontWeight: .w700),
                      overflow: .ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StatusBadge(status: order.status),
            ],
          ),
          const Padding(padding: .symmetric(vertical: 10), child: Divider()),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.icon,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateFormat('MMMM dd, yyyy • hh:mm a').format(order.createdAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (order.status != 'cancelled') ...[
                Expanded(
                  child: CustomButton(
                    height: 40,
                    width: .infinity,
                    text: "Track Order",
                    fontSize: 16,
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => OrderTrackingScreen(order: order),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (order.status == 'pending') ...[
                  Expanded(
                    child: CustomButton(
                      height: 40,
                      width: .infinity,
                      text: "Cancel Order",
                      fontSize: 16,
                      textColor: AppColors.red,
                      buttonColor: AppColors.white,
                      borderSide: const BorderSide(color: AppColors.red),
                      onPressed: () =>
                          _confirmCancel(context, orderProv, orderId),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, OrderProvider provider, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ConfirmationAlertDialog(
        title: 'Cancel Order',
        icon: Icons.cancel_outlined,
        desc: 'Are you sure you want to cancel this order?',
        buttonTxt: 'Yes, Cancel',
        secondaryButtonText: "No",
        onConfirm: () async {
          await provider.cancelOrder(id);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        successMessage: "Order Cancelled Successfully",
      ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  final OrderModel order;
  const _OrderItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _BaseSectionCard(
      child: Column(
        children: order.items.map((item) => OrderItemTile(item: item)).toList(),
      ),
    );
  }
}

class _DeliveryDetailsCard extends StatelessWidget {
  final OrderModel order;
  const _DeliveryDetailsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _BaseSectionCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order.address.name,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                ),
              ),
            ],
          ),
          Padding(
            padding: const .only(left: 30, top: 4),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(order.address.phone, style: textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  "${order.address.address}, ${order.address.district}, ${order.address.city}",
                  style: textTheme.bodySmall?.copyWith(
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
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Scheduled Delivery",
                  style: textTheme.bodySmall?.copyWith(fontWeight: .w700),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(order.scheduledTime!),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: .w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  final OrderModel order;
  const _PaymentSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _BaseSectionCard(
      child: Column(
        children: [
          _PriceRow(label: "Subtotal", price: order.subtotal),
          _PriceRow(label: "Delivery Fee", price: order.deliveryFee),
          if (order.discount > 0)
            _PriceRow(
              label: "Discount",
              price: -order.discount,
              isDiscount: true,
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: textTheme.bodyLarge?.copyWith(fontWeight: .w700),
              ),
              Text(
                "\$${order.totalAmount.toStringAsFixed(2)}",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: .w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const .symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: .circular(8),
            ),
            child: Text(
              "Paid via ${order.paymentMethod.toUpperCase()}",
              textAlign: .center,
              style: textTheme.bodySmall?.copyWith(
                fontStyle: .italic,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseSectionCard extends StatelessWidget {
  final Widget child;
  const _BaseSectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: .circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: .w700,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double price;
  final bool isDiscount;
  const _PriceRow({
    required this.label,
    required this.price,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const .symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: .spaceBetween,
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
              color: isDiscount ? AppColors.success : AppColors.textLight,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
