import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/logic/providers/order_provider.dart';
import 'package:drips_water/presentation/screens/checkout/checkout_sections.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:drips_water/presentation/screens/checkout/payment/add_card_screen.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/components/promo_code_input.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/sections/total_section.dart';
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
        deliveryFee: checkoutProvider.deliveryFee,
        subtotal: currentSubtotal,
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

    final isProcessing = context.select((OrderProvider p) => p.isProcessing);
    final isLoading = isProcessing || _isQuantityLoading;

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

                  OrderSummarySection(
                    items: _displayItems,
                    isBuyNow: _isBuyNow,
                    onIncrement: _isBuyNow ? _incrementBuyNow : null,
                    onDecrement: _isBuyNow ? _decrementBuyNow : null,
                  ),

                  const SizedBox(height: 25),

                  DeliveryAddressDisplay(onAddOrChange: _navigateToAddAddress),

                  const SizedBox(height: 25),

                  const TimeSelectionDisplay(),

                  const SizedBox(height: 25),

                  PaymentHeaderDisplay(onAddCard: _navigateToAddCard),

                  const SizedBox(height: 25),

                  const PaymentMethodDisplay(),

                  const SizedBox(height: 25),

                  PaymentDetailsDisplay(onAddCard: _navigateToAddCard),

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
            bottomNavigationBar: BottomBarDisplay(
              onPlaceOrder: onPlaceOrder,
              isProcessing: isProcessing,
            ),
          ),
        ),
        if (isLoading) const Positioned.fill(child: CustomOverlayLoader()),
      ],
    );
  }
}
