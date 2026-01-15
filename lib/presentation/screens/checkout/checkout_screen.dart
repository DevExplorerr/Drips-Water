import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/credit_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/delivery_time_selection_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/total_section.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/shared/custom_overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final CartItemModel? buyNowItem;
  const CheckoutScreen({super.key, this.buyNowItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String defaultDeliveryOption = "standard";
  bool get showCalendar => defaultDeliveryOption == 'schedule';

  late int _buyNowQuantity;

  @override
  void initState() {
    super.initState();
    _buyNowQuantity = widget.buyNowItem?.quantity ?? 1;
  }

  void _onOptionSelected(String value) {
    setState(() {
      defaultDeliveryOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cartProvider = context.watch<CartProvider>();
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

                          final product = ProductModel(
                            id: item.productId,
                            name: item.name,
                            imageUrl: item.imageUrl,
                            category: '',
                            description: '',
                            sizes: [item.selectedSize],
                            pricePerSize: {
                              item.selectedSize: item.selectedPrice,
                            },
                            rating: 0,
                            reviews: 0,
                            stock: 0,
                          );

                          return CheckoutProductCard(
                            image: item.imageUrl,
                            productName: item.name,
                            selectedPrice: item.selectedPrice,
                            quantity: item.quantity,
                            selectedSize: item.selectedSize,
                            onIncrement: isBuyNow
                                ? () {
                                    setState(() {
                                      _buyNowQuantity++;
                                    });
                                  }
                                : () {
                                    context.read<CartProvider>().addToCart(
                                      product,
                                      item.selectedSize,
                                      1,
                                    );
                                  },
                            onDecrement: isBuyNow
                                ? () {
                                    setState(() {
                                      if (_buyNowQuantity > 1) {
                                        setState(() {
                                          _buyNowQuantity--;
                                        });
                                      }
                                    });
                                  }
                                : () {
                                    context.read<CartProvider>().decrease(
                                      item.productId,
                                      item.selectedSize,
                                    );
                                  },
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
                        onPressed: () {},
                        child: Text(
                          "Change",
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: .w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: .symmetric(horizontal: 15),
                  child: DeliveryAddressSection(),
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
                        isSelected: defaultDeliveryOption == 'standard',
                        onTap: () => _onOptionSelected("standard"),
                      ),
                      const SizedBox(width: 10),
                      DeliveryTimeSelectionCard(
                        width: 190,
                        text: 'Schedule Ahead',
                        time: 'Choose Your Time',
                        value: 'schedule',
                        isSelected: defaultDeliveryOption == 'schedule',
                        onTap: () => _onOptionSelected("schedule"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                if (showCalendar)
                  const Padding(
                    padding: .symmetric(horizontal: 15),
                    child: CheckoutCalendar(),
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
                // If Buy Now: _buyNowQuantity and widget.buyNowItem
                // If Cart: cartProvider.cartItems
              },
            ),
          ),
        ),
        if (cartProvider.isUpdatingQty)
          const Positioned.fill(child: CustomOverlayLoader()),
      ],
    );
  }
}
