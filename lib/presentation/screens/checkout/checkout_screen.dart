import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:drips_water/presentation/screens/checkout/payment/add_card_screen.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/payment_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/total_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/shared/custom_overlay_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final CartItemModel? buyNowItem;
  const CheckoutScreen({super.key, this.buyNowItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late int _buyNowQuantity;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buyNowQuantity = widget.buyNowItem?.quantity ?? 1;
  }

  Future<void> _navigateToAddAddress() async {
    final checkoutProvider = context.read<CheckoutProvider>();

    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DeliveryAddressScreen(
          existingAddress: checkoutProvider.deliveryAddress,
        ),
      ),
    );

    if (result != null && result is AddressModel) {
      if (mounted) {
        context.read<CheckoutProvider>().updateDeliveryAddress(result);
      }
    }
  }

  Future<void> _navigateToAddCard() async {
    final checkoutProvider = context.read<CheckoutProvider>();
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            AddCardScreen(existingCardDetails: checkoutProvider.cardDetails),
      ),
    );

    if (result != null && result is CardModel) {
      if (mounted) {
        context.read<CheckoutProvider>().updateCardDetails(result);
      }
    }
  }

  Future<void> _handleQuantityUpdates(Future<void> Function() action) async {
    setState(() => _isLoading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cartProvider = context.watch<CartProvider>();
    final checkoutProvider = context.watch<CheckoutProvider>();
    final addressData = checkoutProvider.deliveryAddress;
    final isBuyNow = widget.buyNowItem != null;
    final displayItems = isBuyNow
        ? [
            CartItemModel(
              productId: widget.buyNowItem!.productId,
              name: widget.buyNowItem!.name,
              imageUrl: widget.buyNowItem!.imageUrl,
              selectedSize: widget.buyNowItem!.selectedSize,
              selectedPrice: widget.buyNowItem!.selectedPrice,
              quantity: _buyNowQuantity,
            ),
          ]
        : cartProvider.cartItems;

    final buyNowTotal = isBuyNow
        ? (widget.buyNowItem!.selectedPrice * _buyNowQuantity).toDouble()
        : null;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text("Checkout")),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const .symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "Order Summary",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayItems.length,
                        itemBuilder: (context, index) {
                          final item = displayItems[index];

                          return CheckoutProductCard(
                            image: item.imageUrl,
                            productName: item.name,
                            selectedPrice: item.selectedPrice,
                            quantity: item.quantity,
                            selectedSize: item.selectedSize,
                            onIncrement: isBuyNow
                                ? () {
                                    _handleQuantityUpdates(() async {
                                      await Future.delayed(
                                        const Duration(milliseconds: 500),
                                      );

                                      if (mounted) {
                                        setState(() {
                                          _buyNowQuantity++;
                                        });
                                      }
                                    });
                                  }
                                : null,
                            onDecrement: isBuyNow
                                ? () {
                                    _handleQuantityUpdates(() async {
                                      await Future.delayed(
                                        const Duration(milliseconds: 500),
                                      );

                                      if (mounted) {
                                        setState(() {
                                          if (_buyNowQuantity > 1) {
                                            _buyNowQuantity--;
                                          }
                                        });
                                      }
                                    });
                                  }
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const .symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Delivery Address",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      TextButton(
                        style: theme.textButtonTheme.style,
                        onPressed: _navigateToAddAddress,
                        child: Text(
                          addressData == null ? "+ Add" : "Change",
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: .w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const .symmetric(horizontal: 15),
                  child: addressData == null
                      ? const Text("No address selected")
                      : DeliveryAddressSection(
                          name: addressData.name,
                          phoneNumber: addressData.phone,
                          fullAddress:
                              "${addressData.address} ${addressData.district}, ${addressData.city} - ${addressData.region}",
                        ),
                ),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: .horizontal,
                  padding: const .symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      DeliveryTimeSelectionCard(
                        width: 143,
                        text: 'Standard',
                        time: '20-30 Min',
                        value: 'standard',
                        isSelected:
                            checkoutProvider.deliveryOption == 'standard',
                        onTap: () =>
                            checkoutProvider.setDeliveryOption('standard'),
                      ),
                      const SizedBox(width: 10),
                      DeliveryTimeSelectionCard(
                        width: 190,
                        text: 'Schedule Ahead',
                        time: 'Choose Your Time',
                        value: 'schedule',
                        isSelected:
                            checkoutProvider.deliveryOption == 'schedule',
                        onTap: () =>
                            checkoutProvider.setDeliveryOption('schedule'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                if (checkoutProvider.showCalendar)
                  Padding(
                    padding: const .symmetric(horizontal: 15),
                    child: CheckoutCalendar(
                      initialDate: checkoutProvider.scheduledTime,
                      onDateTimeChanged: (newDate) {
                        checkoutProvider.setScheduledTime(newDate);
                      },
                    ),
                  ),
                const SizedBox(height: 25),
                Padding(
                  padding: .symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Payment",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      if (checkoutProvider.paymentMethod == 'card')
                        GestureDetector(
                          onTap: _navigateToAddCard,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColors.icon,
                                size: 15,
                              ),
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
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const .symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      PaymentSelectionCard(
                        title: "Cash on Delivery",
                        icon: Icons.money,
                        isSelected: checkoutProvider.paymentMethod == 'cod',
                        onTap: () => checkoutProvider.setPaymentMethod('cod'),
                      ),
                      const SizedBox(height: 10),
                      PaymentSelectionCard(
                        title: "Credit / Debit Card",
                        icon: Icons.credit_card,
                        isSelected: checkoutProvider.paymentMethod == 'card',
                        onTap: () => checkoutProvider.setPaymentMethod('card'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                if (checkoutProvider.paymentMethod == 'cod')
                  Container(
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
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (checkoutProvider.paymentMethod == 'card')
                  Center(
                    child: checkoutProvider.cardDetails == null
                        ? GestureDetector(
                            onTap: _navigateToAddCard,
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
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: _navigateToAddCard,
                            child: Center(
                              child: CreditCard(
                                cardType:
                                    checkoutProvider.cardDetails!.cardType,
                                cardNumber:
                                    checkoutProvider.cardDetails!.maskedNumber,
                                cardHolderName:
                                    checkoutProvider.cardDetails!.holderName,
                                expiryDate:
                                    checkoutProvider.cardDetails!.expiryDate,
                              ),
                            ),
                          ),
                  ),

                const SizedBox(height: 50),
                Padding(
                  padding: const .only(left: 15, right: 15, bottom: 15),
                  child: TotalSection(overrideTotal: buyNowTotal),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
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
              onPressed: () {
                if (checkoutProvider.deliveryAddress == null) {
                  showFloatingSnackBar(
                    context,
                    message: "Please select an address",
                    backgroundColor: AppColors.error,
                  );
                  return;
                }
                // If Buy Now: _buyNowQuantity and widget.buyNowItem
                // If Cart: cartProvider.cartItems
              },
            ),
          ),
        ),
        if (_isLoading) const Positioned.fill(child: CustomOverlayLoader()),
      ],
    );
  }
}
