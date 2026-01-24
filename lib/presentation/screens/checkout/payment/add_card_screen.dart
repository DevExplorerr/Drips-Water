import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/presentation/widgets/buttons/custom_button.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddCardScreen extends StatefulWidget {
  final CardModel? existingCardDetails;
  const AddCardScreen({super.key, this.existingCardDetails});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool get isEditing => widget.existingCardDetails != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _numberController.text = widget.existingCardDetails!.cardNumber;
      _nameController.text = widget.existingCardDetails!.holderName;
      _expiryController.text = widget.existingCardDetails!.expiryDate;
      _cvvController.text = widget.existingCardDetails!.cvv;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

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
        padding: const .all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: "Card Holder Name",
                hintText: "e.g. John Doe",
                textInputType: .name,
                validator: (v) => v!.isEmpty ? "Required" : null,
                textInputAction: .next,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _numberController,
                labelText: "Card Number",
                hintText: "0000 0000 0000 0000",
                textInputType: .number,
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
                      textInputType: .datetime,
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
                      textInputType: .number,
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
        padding: .only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.of(context).padding.bottom + 15,
        ),
        child: CustomButton(
          onPressed: _saveCard,
          height: 50,
          width: .infinity,
          text: "Save",
        ),
      ),
    );
  }
}
