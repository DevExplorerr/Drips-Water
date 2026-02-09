import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/common/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/common/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/components/credit_card_widget.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/payment_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/time_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSummarySection extends StatelessWidget {
  final List<CartItemModel> items;
  final bool isBuyNow;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  const OrderSummarySection({
    super.key,
    required this.items,
    required this.isBuyNow,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "Order Summary",
            style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
          ),
          const SizedBox(height: 10),

          Column(
            children: items.map((item) {
              return CheckoutProductCard(
                image: item.imageUrl,
                productName: item.name,
                selectedPrice: item.selectedPrice,
                quantity: item.quantity,
                selectedSize: item.selectedSize,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DeliveryAddressDisplay extends StatelessWidget {
  final VoidCallback onAddOrChange;
  const DeliveryAddressDisplay({super.key, required this.onAddOrChange});

  @override
  Widget build(BuildContext context) {
    final address = context.select((CheckoutProvider p) => p.deliveryAddress);
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const .symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Delivery Address",
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .w700),
              ),
              TextButton(
                style: theme.textButtonTheme.style,
                onPressed: onAddOrChange,
                child: Text(
                  address == null ? "+ Add" : "Change",
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: .w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const .symmetric(horizontal: 15),
          child: address == null
              ? const Text("No address selected")
              : AddressSection(
                  name: address.name,
                  phoneNumber: address.phone,
                  fullAddress:
                      "${address.address} ${address.district}, ${address.city} - ${address.region}",
                ),
        ),
      ],
    );
  }
}

class TimeSelectionDisplay extends StatelessWidget {
  const TimeSelectionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, _) {
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 15),
              child: Row(
                children: [
                  TimeSection(
                    width: 143,
                    text: 'Standard',
                    time: '20-30 Min',
                    value: 'standard',
                    isSelected: checkoutProvider.deliveryOption == 'standard',
                    onTap: () => checkoutProvider.setDeliveryOption('standard'),
                  ),
                  const SizedBox(width: 10),
                  TimeSection(
                    width: 190,
                    text: 'Schedule Ahead',
                    time: 'Choose Your Time',
                    value: 'schedule',
                    isSelected: checkoutProvider.deliveryOption == 'schedule',
                    onTap: () => checkoutProvider.setDeliveryOption('schedule'),
                  ),
                ],
              ),
            ),
            if (checkoutProvider.showCalendar) ...[
              const SizedBox(height: 25),
              Padding(
                padding: const .symmetric(horizontal: 15),
                child: CheckoutCalendar(
                  initialDate: checkoutProvider.scheduledTime,
                  onDateTimeChanged: (newDate) =>
                      checkoutProvider.setScheduledTime(newDate),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class PaymentHeaderDisplay extends StatelessWidget {
  final VoidCallback onAddCard;
  const PaymentHeaderDisplay({super.key, required this.onAddCard});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, _) {
        return Padding(
          padding: .symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Payment",
                style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
              ),
              if (checkoutProvider.paymentMethod == 'card')
                GestureDetector(
                  onTap: onAddCard,
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: AppColors.icon, size: 15),
                      const SizedBox(width: 5),
                      Text(
                        checkoutProvider.cardDetails == null
                            ? "Add New Card"
                            : "Edit Card Details",
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentMethodDisplay extends StatelessWidget {
  const PaymentMethodDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, _) {
        return Padding(
          padding: const .symmetric(horizontal: 15),
          child: Column(
            children: [
              PaymentSection(
                title: "Cash on Delivery",
                icon: Icons.money,
                isSelected: checkoutProvider.paymentMethod == 'cod',
                onTap: () => checkoutProvider.setPaymentMethod('cod'),
              ),
              const SizedBox(height: 10),
              PaymentSection(
                title: "Credit / Debit Card",
                icon: Icons.credit_card,
                isSelected: checkoutProvider.paymentMethod == 'card',
                onTap: () => checkoutProvider.setPaymentMethod('card'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentDetailsDisplay extends StatelessWidget {
  final VoidCallback onAddCard;
  const PaymentDetailsDisplay({super.key, required this.onAddCard});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, _) {
        if (checkoutProvider.paymentMethod == 'cod') {
          return Container(
            margin: const .symmetric(horizontal: 15),
            padding: const .all(15),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              borderRadius: .circular(8),
              border: .all(color: AppColors.grey),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "You will pay when the water arrives.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }

        if (checkoutProvider.paymentMethod == 'card') {
          return Center(
            child: checkoutProvider.cardDetails == null
                ? GestureDetector(
                    onTap: onAddCard,
                    child: Container(
                      height: 140,
                      width: 270,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.1),
                        borderRadius: .circular(14),
                        border: .all(
                          color: AppColors.grey.withValues(alpha: 0.3),
                          style: .solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          const Icon(
                            Icons.add_card,
                            size: 40,
                            color: AppColors.icon,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Add a Credit Card",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onAddCard,
                    child: Center(
                      child: CreditCardWidget(
                        cardType: checkoutProvider.cardDetails!.cardType,
                        cardNumber: checkoutProvider.cardDetails!.maskedNumber,
                        cardHolderName:
                            checkoutProvider.cardDetails!.holderName,
                        expiryDate: checkoutProvider.cardDetails!.expiryDate,
                      ),
                    ),
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class BottomBarDisplay extends StatelessWidget {
  final VoidCallback onPlaceOrder;
  final bool isProcessing;
  const BottomBarDisplay({
    super.key,
    required this.onPlaceOrder,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(
        left: 15,
        right: 15,
        top: 15,
        bottom: MediaQuery.of(context).padding.bottom + 15,
      ),
      child: CustomButton(
        height: 50,
        width: .infinity,
        text: "Place Order",
        onPressed: isProcessing ? null : onPlaceOrder,
      ),
    );
  }
}
