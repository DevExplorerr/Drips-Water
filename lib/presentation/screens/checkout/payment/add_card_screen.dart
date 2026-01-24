import 'package:drips_water/core/constants/app_colors.dart';
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

  String _selectedCardType = "Visa";
  final List<String> _cardTypes = [
    "Visa",
    "MasterCard",
    "American Express",
    "Discover",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingCardDetails != null) {
      _numberController.text = widget.existingCardDetails!.cardNumber;
      _nameController.text = widget.existingCardDetails!.holderName;
      _expiryController.text = widget.existingCardDetails!.expiryDate;
      _cvvController.text = widget.existingCardDetails!.cvv;
      _selectedCardType = widget.existingCardDetails!.cardType;
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
        cardType: _selectedCardType,
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
            crossAxisAlignment: .start,
            children: [
              Text(
                "Card Type",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: .w600,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const .symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                  border: .all(color: Colors.transparent),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: AppColors.primary,
                    value: _selectedCardType,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.icon,
                    ),
                    items: _cardTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontWeight: .w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCardType = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
