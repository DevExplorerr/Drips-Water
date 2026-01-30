import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
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

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _controller,
                textInputType: .text,
                textInputAction: .done,
                hintText: "Enter Promo Code",
                labelText: "Promo Code",
                isEnabled: !isApplied,
              ),
            ),
            const SizedBox(width: 10),
            // Apply / Remove Button
            Expanded(
              child: CustomButton(
                height: 50,
                width: 0,
                text: isApplied ? "Remove" : "Apply",
                textColor: isApplied ? AppColors.error : AppColors.white,
                onPressed: () {
                  if (isApplied) {
                    checkoutProvider.removePromoCode();
                    _controller.clear();
                  } else {
                    if (_controller.text.isNotEmpty) {
                      checkoutProvider.validatePromoCode(
                        _controller.text.trim(),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
        // Error Message
        if (checkoutProvider.promoError != null)
          Padding(
            padding: const .only(top: 5, left: 5),
            child: Text(
              checkoutProvider.promoError!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        // Success Message
        if (isApplied)
          Padding(
            padding: const .only(top: 5, left: 5),
            child: Text(
              "Code '${checkoutProvider.appliedPromo!.code}' applied!",
              style: const TextStyle(color: AppColors.success, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
