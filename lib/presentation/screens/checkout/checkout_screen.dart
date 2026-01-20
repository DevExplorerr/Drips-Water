import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
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
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColors.icon,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Add New Card",
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
                const Center(child: CreditCard()),
                const SizedBox(height: 50),
                Padding(
                  padding: const .only(left: 15, right: 15, bottom: 15),
                  child: TotalSection(overrideTotal: buyNowTotal),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: const .all(15),
            height: 80,
            color: Colors.transparent,
            elevation: 0,
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
