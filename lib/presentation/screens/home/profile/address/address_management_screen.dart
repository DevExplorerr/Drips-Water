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
              stream: context.watch<AddressProvider>().addressStream,
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

                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) =>
                      _AddressCard(address: addresses[index]),
                );
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
      onTap: () {
        context.read<AddressProvider>().selectAddress(address);
        context.read<CheckoutProvider>().setDeliveryAddress(address);

        Navigator.pop(context);
      },
      child: Card(
        margin: const .only(bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: .circular(10),
          side: isSelected ? const BorderSide(color: AppColors.primary) : .none,
        ),
        child: ListTile(
          contentPadding: const .symmetric(horizontal: 15, vertical: 5),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  address.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: .w700,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(address.phone, style: textTheme.bodySmall),
              const SizedBox(width: 8),
              const Spacer(),
              TextButton(
                child: Text(
                  "Edit",
                  style: textTheme.bodySmall?.copyWith(decoration: .underline),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          AddressFormScreen(existingAddress: address),
                    ),
                  );
                },
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                address.address,
                style: textTheme.bodySmall,
                maxLines: 2,
                overflow: .ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    "${address.district}, ${address.city}",
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
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
                      color: AppColors.red,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : const Icon(Icons.check_circle_outline, color: AppColors.grey),
        ),
      ),
    );
  }
}
