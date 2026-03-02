import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  CupertinoPageRoute(
                    builder: (_) => const DeliveryAddressScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            Text("Your Saved Addresses", style: textTheme.titleSmall),
            const Padding(
              padding: .only(top: 10, bottom: 10),
              child: Divider(),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const _AddressCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

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
                "Name",
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: .w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text("Phone Number", style: textTheme.bodySmall),
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
                "Full Address",
                style: textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text("District", style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
