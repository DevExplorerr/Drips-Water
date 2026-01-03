import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final String text;
  final Color? color;
  final Color? textColor;
  final BorderSide? borderSide;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.text,
    this.color,
    this.textColor,
    this.borderSide,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(elevation),
          backgroundColor: WidgetStatePropertyAll(
            color ??
                theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          ),
          overlayColor: WidgetStatePropertyAll(
            textColor ??
                theme.elevatedButtonTheme.style?.overlayColor?.resolve({}),
          ),
          side: WidgetStatePropertyAll(borderSide),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor ?? AppColors.textDark,
            fontWeight: .w700,
          ),
        ),
      ),
    );
  }
}
