import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/delivery/delivery_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipping Addresses"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP SECTION: ADD NEW ADDRESS
            _buildAddAddressButton(context),

            const SizedBox(height: 30),
            Text("Your Saved Addresses", style: textTheme.titleMedium),
            const Divider(),

            // BOTTOM SECTION: LIST OF ADDRESSES
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildAddressCard(context, textTheme);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to your existing Form screen (used in Checkout)
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const DeliveryAddressScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          color: AppColors.primary.withOpacity(0.05),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_location_alt_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              "Add New Address",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, TextTheme textTheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Row(
          children: [
            Text(
              "Other",
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("XYZ", style: textTheme.bodySmall),
            const SizedBox(height: 5),
            Text(
              "Karachi",
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
