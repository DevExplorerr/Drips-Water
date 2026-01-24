import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      final card = CardModel(
        cardNumber: _numberController.text.trim(),
        holderName: _nameController.text.trim(),
        expiryDate: _expiryController.text.trim(),
        cvv: _cvvController.text.trim(),
      );
      Navigator.pop(context, card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Card")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: "Card Holder Name",
                hintText: "e.g. John Doe",
                textInputType: TextInputType.name,
                validator: (v) => v!.isEmpty ? "Required" : null,
                textInputAction: .next,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _numberController,
                labelText: "Card Number",
                hintText: "0000 0000 0000 0000",
                textInputType: TextInputType.number,
                validator: (v) => (v!.length < 12) ? "Invalid Number" : null,
                textInputAction: .next,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _expiryController,
                      labelText: "Expiry Date",
                      hintText: "MM/YY",
                      textInputType: TextInputType.datetime,
                      validator: (v) => v!.isEmpty ? "Required" : null,
                      textInputAction: .next,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      controller: _cvvController,
                      labelText: "CVV",
                      hintText: "123",
                      textInputType: TextInputType.number,
                      validator: (v) => (v!.length < 3) ? "Invalid CVV" : null,
                      textInputAction: .done,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
          text: "Save Card",
          onPressed: _saveCard,
          height: 50,
          width: double.infinity,
        ),
      ),
    );
  }
}
