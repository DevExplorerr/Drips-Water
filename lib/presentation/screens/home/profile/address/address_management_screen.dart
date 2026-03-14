import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/logic/providers/address_provider.dart';
import 'package:drips_water/logic/providers/checkout_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/dialog/confirmation_alert_dialog.dart';
import 'package:drips_water/presentation/widgets/forms/address_form_screen.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Addresses")),
      body: SingleChildScrollView(
        padding: const .all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            CustomButton(
              height: 70,
              width: .infinity,
              text: "Add New Address",
              textColor: AppColors.primary,
              buttonColor: AppColors.white,
              borderSide: const BorderSide(color: AppColors.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const AddressFormScreen()),
                );
              },
            ),

            const SizedBox(height: 40),
            Text("Your Saved Addresses", style: textTheme.titleSmall),
            const Padding(
              padding: .only(top: 10, bottom: 10),
              child: Divider(),
            ),

            StreamBuilder<List<AddressModel>>(
              stream: context.read<AddressProvider>().addressStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 40,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: .symmetric(horizontal: 15),
                    child: AppEmptyState(
                      title: 'No Saved Addresses Found',
                      description:
                          'Save your home or office address to make checkout faster and easier.',
                      icon: Icons.home_outlined,
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final addresses = snapshot.data!;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<AddressProvider>().syncAddresses(addresses);
                    context.read<CheckoutProvider>().updateFromList(addresses);
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) =>
                        _AddressCard(address: addresses[index]),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isSelected =
        context.watch<AddressProvider>().selectedAddress?.id == address.id;

    return GestureDetector(
      onTap: () async {
        final addressProvider = context.read<AddressProvider>();
        final checkoutProvider = context.read<CheckoutProvider>();
        final navigator = Navigator.of(context);

        navigator.pop();

        await addressProvider.setAsDefault(address.id!);

        checkoutProvider.setDeliveryAddress(address);
      },
      child: Container(
        margin: const .only(bottom: 16),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Container(
                  padding: const .symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(20),
                  ),
                  child: Text(
                    address.label.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: .w700,
                      letterSpacing: 1,
                      fontSize: 12,
                    ),
                  ),
                ),
                isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20,
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.grey,
                        size: 20,
                      ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.name,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: .w700,
                      color: AppColors.textLight,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
                Text(address.phone, style: textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${address.address}, ${address.district}, ${address.city}",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: .end,
              children: [
                TextButton.icon(
                  style: Theme.of(context).textButtonTheme.style,
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          AddressFormScreen(existingAddress: address),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.icon,
                  ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(
                      color: AppColors.textLight,
                      decoration: .underline,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationAlertDialog(
                        onConfirm: () async {
                          final addressProvider = context
                              .read<AddressProvider>();

                          await addressProvider.deleteAddress(address.id!);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        title: "Delete Address",
                        icon: Icons.delete_outline,
                        desc: "Are you sure you want to remove this address?",
                        buttonTxt: "Delete",
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.red,
                  ),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
