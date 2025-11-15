import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';

class InputArea extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  const InputArea({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.send,
              hintText: "Ask something...",
              onFieldSubmitted: onSend,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: AppColors.white),
              onPressed: () => onSend(controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
