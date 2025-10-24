import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? obscureText;
  final TextInputAction textInputAction;
  final String hintText;
  final IconButton? suffixIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.textInputType,
    this.obscureText,
    required this.textInputAction,
    required this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          style: textTheme.bodySmall,
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText ?? false,
          textInputAction: textInputAction,
          autofocus: false,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: theme.inputDecorationTheme.hintStyle,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
          ),
        ),
      ],
    );
  }
}
