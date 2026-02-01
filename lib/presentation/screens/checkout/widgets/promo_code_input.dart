import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoCodeInput extends StatefulWidget {
  const PromoCodeInput({super.key});

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = context.watch<CheckoutProvider>();
    final isApplied = checkoutProvider.appliedPromo != null;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: isApplied
                ? AppColors.success.withValues(alpha: 0.05)
                : AppColors.white,
            borderRadius: .circular(12),
            border: .all(
              color: isApplied
                  ? AppColors.success
                  : (checkoutProvider.promoError != null
                        ? AppColors.error
                        : AppColors.grey.withValues(alpha: 0.3)),
              width: 1.5,
            ),
          ),
          padding: const .symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Padding(
                padding: const .only(left: 10, right: 10),
                child: Icon(
                  isApplied
                      ? Icons.check_circle
                      : Icons.confirmation_number_outlined,
                  color: isApplied ? AppColors.success : AppColors.grey,
                  size: 22,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: .done,
                  textCapitalization: .characters,
                  keyboardType: .text,
                  enabled: !isApplied,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: .w600,
                    color: AppColors.textLight,
                    letterSpacing: 1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Promo Code",
                    hintStyle: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (!isApplied && _controller.text.isNotEmpty) {
                      checkoutProvider.validatePromoCode(
                        _controller.text.trim(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const .symmetric(vertical: 5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isApplied
                        ? AppColors.error
                        : AppColors.primary,
                    padding: const .symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    backgroundColor: isApplied
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.primary,
                  ),
                  onPressed: () {
                    if (isApplied) {
                      checkoutProvider.removePromoCode();
                      _controller.clear();
                    } else {
                      if (_controller.text.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        checkoutProvider.validatePromoCode(
                          _controller.text.trim(),
                        );
                      }
                    }
                  },
                  child: Text(
                    isApplied ? "Remove" : "Apply",
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: .bold,
                      color: isApplied ? AppColors.error : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Error Message
        if (checkoutProvider.promoError != null)
          Padding(
            padding: const .only(top: 8, left: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: 5),
                Text(
                  checkoutProvider.promoError!,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),

        // Success Message
        if (isApplied)
          Padding(
            padding: const .only(top: 5, left: 5),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: AppColors.success),
                const SizedBox(width: 5),
                Text(
                  "Code '${checkoutProvider.appliedPromo!.code}' applied!",
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: .bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
