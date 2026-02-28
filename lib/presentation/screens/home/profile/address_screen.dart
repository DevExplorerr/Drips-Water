import 'package:flutter/material.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: Load existing address from your Firestore/ViewModel here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Address"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              labelText: "Delivery Address",
              hintText: "Street, House No, Area",
              controller: addressController,
              textInputType: .text,
              textInputAction: .next,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: "Phone Number",
              hintText: "+92...",
              controller: phoneController,
              textInputType: .phone,
              textInputAction: .next,
            ),
            const Spacer(),
            CustomButton(
              text: isLoading ? "SAVING..." : "SAVE ADDRESS",
              onPressed: () async {
                setState(() => isLoading = true);
                // await userService.saveAddress(...);
                if (mounted) {
                  setState(() => isLoading = false);
                  Navigator.pop(context);
                }
              },
              height: 50,
              width: .infinity,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
