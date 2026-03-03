import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/logic/providers/address_provider.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/address_form_screen.dart';
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
                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 40,
                    ),
                  );
                }

                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
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
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const .only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: .circular(10)),
        child: ListTile(
          contentPadding: const .only(top: 5, bottom: 5, left: 15, right: 15),
          title: Row(
            children: [
              Text(
                address.name,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: .w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(address.phone, style: textTheme.bodySmall),
              const Spacer(),
              TextButton(
                child: Text(
                  "Edit",
                  style: textTheme.bodySmall?.copyWith(decoration: .underline),
                ),
                onPressed: () {},
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
              const SizedBox(height: 5),
              Text(
                "${address.district}, ${address.city}",
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
