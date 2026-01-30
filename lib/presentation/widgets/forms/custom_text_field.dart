import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? obscureText;
  final TextInputAction textInputAction;
  final String hintText;
  final IconButton? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? isEnabled;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.controller,
    required this.textInputType,
    this.obscureText,
    required this.textInputAction,
    required this.hintText,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.validator,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Text(
            labelText!,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
        ],
        TextFormField(
          style: textTheme.bodySmall,
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText ?? false,
          textInputAction: textInputAction,
          autofocus: false,
          validator: validator,
          enabled: isEnabled,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: theme.inputDecorationTheme.hintStyle,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
            errorBorder: theme.inputDecorationTheme.errorBorder,
            focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
          ),
        ),
      ],
    );
  }
}
