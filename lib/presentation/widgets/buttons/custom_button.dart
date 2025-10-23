import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double? fontSize;
  final String text;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.text,
    this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
