import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;
  final Color? color;

  const AppBadge({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Text(
        text,
        style:
            textStyle ??
            Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
