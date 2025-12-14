import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final String text;
  final Color? color;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.text,
    this.color,
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
          backgroundColor: WidgetStatePropertyAll(
            color ??
                Theme.of(
                  context,
                ).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          ),
        ),
        child: Text(
          text,
          style: theme.elevatedButtonTheme.style!.textStyle?.resolve({}),
        ),
      ),
    );
  }
}
