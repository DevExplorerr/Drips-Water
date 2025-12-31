import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  final String title;

  const SheetHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const SizedBox(width: 40), // symmetry
        Expanded(
          child: Center(
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
