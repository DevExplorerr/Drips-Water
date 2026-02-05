import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/logic/providers/order_provider.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:drips_water/presentation/screens/checkout/payment/add_card_screen.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/common/checkout_calendar.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/common/checkout_product_card.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/components/credit_card_widget.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/address_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/time_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/payment_section.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/components/promo_code_input.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/total_section.dart';
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
  bool _isQuantityLoading = false;

  @override
  void initState() {
    super.initState();
    _buyNowQuantity = widget.buyNowItem?.quantity ?? 1;
  }

  // Getters

  bool get _isBuyNow => widget.buyNowItem != null;

  List<CartItemModel> get _displayItems {
    if (!_isBuyNow) return context.read<CartProvider>().cartItems;
    return [
      CartItemModel(
        productId: widget.buyNowItem!.productId,
        name: widget.buyNowItem!.name,
        imageUrl: widget.buyNowItem!.imageUrl,
        selectedSize: widget.buyNowItem!.selectedSize,
        selectedPrice: widget.buyNowItem!.selectedPrice,
        quantity: _buyNowQuantity,
      ),
    ];
  }

  double get _subTotal {
    if (!_isBuyNow) {
      return (widget.buyNowItem!.selectedPrice * _buyNowQuantity).toDouble();
    }
    return context.read<CartProvider>().totalPrice;
  }

  // Navigation Methods

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

    if (result != null && result is AddressModel && mounted) {
      checkoutProvider.updateDeliveryAddress(result);
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

    if (result != null && result is CardModel && mounted) {
      checkoutProvider.updateCardDetails(result);
    }
  }

  // Logic Methods

  Future<void> _handleQuantityUpdates(Future<void> Function() action) async {
    setState(() => _isQuantityLoading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isQuantityLoading = false);
    }
  }

  void _incrementBuyNow() {
    _handleQuantityUpdates(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => _buyNowQuantity++);
    });
  }

  void _decrementBuyNow() {
    _handleQuantityUpdates(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _buyNowQuantity > 1) setState(() => _buyNowQuantity--);
    });
  }

  Future<void> onPlaceOrder() async {
    final navigator = Navigator.of(context);
    final checkoutProvider = context.read<CheckoutProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (checkoutProvider.deliveryAddress == null) {
      showFloatingSnackBar(
        context,
        message: "Please select an address",
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (checkoutProvider.paymentMethod == 'card' &&
        checkoutProvider.cardDetails == null) {
      showFloatingSnackBar(
        context,
        message: "Please add your card details",
        backgroundColor: AppColors.error,
      );
      return;
    }

    final currentSubtotal = _subTotal;
    final currentDiscount = checkoutProvider.calculateDiscount(currentSubtotal);
    final currentTotal = checkoutProvider.calculateFinalTotal(currentSubtotal);

    try {
      final orderId = await orderProvider.placeOrder(
        userId: checkoutProvider.uid,
        items: _displayItems,
        address: checkoutProvider.deliveryAddress!,
        paymentMethod: checkoutProvider.paymentMethod,
        deliveryOption: checkoutProvider.deliveryOption,
        scheduledTime: checkoutProvider.deliveryOption == 'schedule'
            ? checkoutProvider.scheduledTime
            : null,
        subtotal: currentSubtotal,
        deliveryFee: checkoutProvider.deliveryFee,
        discount: currentDiscount,
        totalAmount: currentTotal,
      );

      if (!mounted) return;

      if (orderId != null) {
        if (!_isBuyNow) cartProvider.clearCart();
        showFloatingSnackBar(
          context,
          message: "Order Success!",
          backgroundColor: AppColors.success,
        );
        navigator.popUntil((route) => route.isFirst);
      }
    } catch (e) {
      showFloatingSnackBar(
        context,
        message: e.toString(),
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final bool isPageLoading = context.select<OrderProvider, bool>(
      (p) => p.isProcessing || _isQuantityLoading,
    );

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(title: const Text("Checkout")),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 10),
                  _buildOrderSummary(textTheme),
                  const SizedBox(height: 25),
                  _buildDeliverySection(theme),
                  const SizedBox(height: 10),
                  _buildAddressDisplay(),
                  const SizedBox(height: 25),
                  _buildTimeSection(),
                  const SizedBox(height: 25),
                  if (context.watch<CheckoutProvider>().showCalendar) ...[
                    _buildCalendar(),
                    const SizedBox(height: 25),
                  ],
                  _buildPaymentHeader(textTheme),
                  const SizedBox(height: 25),
                  _buildPaymentMethods(),
                  const SizedBox(height: 25),
                  _buildPaymentDetailsDisplay(textTheme),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: .symmetric(horizontal: 15),
                    child: PromoCodeInput(),
                  ),

                  const SizedBox(height: 50),
                  Padding(
                    padding: const .only(left: 15, right: 15, bottom: 15),
                    child: TotalSection(
                      overrideTotal: _isBuyNow ? _subTotal : null,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomBar(
              context.watch<OrderProvider>().isProcessing,
            ),
          ),
        ),
        if (isPageLoading) const Positioned.fill(child: CustomOverlayLoader()),
      ],
    );
  }

  Widget _buildOrderSummary(TextTheme textTheme) {
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

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _displayItems.length,
            itemBuilder: (context, index) {
              final item = _displayItems[index];

              return CheckoutProductCard(
                image: item.imageUrl,
                productName: item.name,
                selectedPrice: item.selectedPrice,
                quantity: item.quantity,
                selectedSize: item.selectedSize,
                onIncrement: _isBuyNow ? () => _incrementBuyNow() : null,
                onDecrement: _isBuyNow ? () => _decrementBuyNow() : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(ThemeData theme) {
    final address = context.watch<CheckoutProvider>().deliveryAddress;
    return Padding(
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
            onPressed: _navigateToAddAddress,
            child: Text(
              address == null ? "+ Add" : "Change",
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: .w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDisplay() {
    final address = context.watch<CheckoutProvider>().deliveryAddress;
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: address == null
          ? const Text("No address selected")
          : AddressSection(
              name: address.name,
              phoneNumber: address.phone,
              fullAddress:
                  "${address.address} ${address.district}, ${address.city} - ${address.region}",
            ),
    );
  }

  Widget _buildTimeSection() {
    final checkoutProvider = context.watch<CheckoutProvider>();
    return SingleChildScrollView(
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
    );
  }

  Widget _buildCalendar() {
    final checkoutProvider = context.watch<CheckoutProvider>();
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: CheckoutCalendar(
        initialDate: checkoutProvider.scheduledTime,
        onDateTimeChanged: (newDate) {
          checkoutProvider.setScheduledTime(newDate);
        },
      ),
    );
  }

  Widget _buildPaymentHeader(TextTheme textTheme) {
    final checkoutProvider = context.watch<CheckoutProvider>();
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
              onTap: _navigateToAddCard,
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
  }

  Widget _buildPaymentMethods() {
    final checkoutProvider = context.watch<CheckoutProvider>();
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
  }

  Widget _buildPaymentDetailsDisplay(TextTheme textTheme) {
    final checkoutProvider = context.watch<CheckoutProvider>();

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
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    if (checkoutProvider.paymentMethod == 'card') {
      return Center(
        child: checkoutProvider.cardDetails == null
            ? _buildAddCardPlaceHolder(textTheme)
            : GestureDetector(
                onTap: _navigateToAddCard,
                child: Center(
                  child: CreditCardWidget(
                    cardType: checkoutProvider.cardDetails!.cardType,
                    cardNumber: checkoutProvider.cardDetails!.maskedNumber,
                    cardHolderName: checkoutProvider.cardDetails!.holderName,
                    expiryDate: checkoutProvider.cardDetails!.expiryDate,
                  ),
                ),
              ),
      );
    }
    return const SizedBox();
  }

  Widget _buildAddCardPlaceHolder(TextTheme textTheme) {
    return GestureDetector(
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
            const Icon(Icons.add_card, size: 40, color: AppColors.icon),
            const SizedBox(height: 10),
            Text("Add a Credit Card", style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isProcessing) {
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
