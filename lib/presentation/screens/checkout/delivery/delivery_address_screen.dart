import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/global/snackbar.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final AddressModel? existingAddress;
  const DeliveryAddressScreen({super.key, this.existingAddress});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController recipientName = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  bool get isEditing => widget.existingAddress != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      recipientName.text = widget.existingAddress!.name;
      phoneController.text = widget.existingAddress!.phone;
      regionController.text = widget.existingAddress!.region;
      cityController.text = widget.existingAddress!.city;
      districtController.text = widget.existingAddress!.district;
      addressController.text = widget.existingAddress!.address;
      instructionsController.text = widget.existingAddress!.instructions ?? '';
    }
  }

  @override
  void dispose() {
    recipientName.dispose();
    phoneController.dispose();
    regionController.dispose();
    cityController.dispose();
    districtController.dispose();
    addressController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      final addressModel = AddressModel(
        name: recipientName.text.trim(),
        phone: phoneController.text.trim(),
        region: regionController.text.trim(),
        city: cityController.text.trim(),
        district: districtController.text.trim(),
        address: addressController.text.trim(),
        instructions: instructionsController.text.trim(),
        label: "Home",
      );
      Navigator.pop(context, addressModel);
    } else {
      showFloatingSnackBar(
        context,
        message: 'Please fix the errors in red before saving.',
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            isEditing ? "Edit Shipping Address" : "Add Shipping Address",
          ),
        ),
        body: SingleChildScrollView(
          padding: const .all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: recipientName,
                  textInputType: .name,
                  textInputAction: .next,
                  hintText: "Input the real name",
                  labelText: "Recipient's Name *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recipient name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: phoneController,
                  textInputType: .phone,
                  textInputAction: .next,
                  hintText: "Please Input Phone Number",
                  labelText: "Phone Number *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter valid digits only';
                    }
                    if (value.length < 10 || value.length > 15) {
                      return 'Enter a valid phone number (10-15 digits)';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                CustomTextField(
                  controller: regionController,
                  textInputType: .streetAddress,
                  textInputAction: .next,
                  hintText: "Please Input Region, e.g: Sindh",
                  labelText: "Region *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Region is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: cityController,
                  textInputType: .streetAddress,
                  textInputAction: .next,
                  hintText: "Please Input City, e.g: Karachi",
                  labelText: "City *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: districtController,
                  textInputType: .streetAddress,
                  textInputAction: .next,
                  hintText: "Please Input District, e.g: Shadman Town",
                  labelText: "District *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'District is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: addressController,
                  textInputType: .streetAddress,
                  textInputAction: .next,
                  hintText: "House no./building/street/area",
                  labelText: "Address *",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Address is required';
                    }
                    if (value.trim().length < 5) {
                      return 'Please provide a more detailed address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: instructionsController,
                  textInputType: .text,
                  textInputAction: .done,
                  hintText: "e.g. Gate code 1234, Leave at door",
                  labelText: "Delivery Instructions (Optional)",
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: .only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).padding.bottom + 15,
          ),
          child: CustomButton(
            onPressed: _validateAndSave,
            height: 50,
            width: .infinity,
            text: "Save",
          ),
        ),
      ),
    );
  }
}
