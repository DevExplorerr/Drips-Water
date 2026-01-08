import 'package:flutter/material.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Home Address",
          style: textTheme.bodySmall?.copyWith(fontWeight: .w600),
        ),
        const SizedBox(height: 5),
        Text("123 Street, Karachi, Pakistan", style: textTheme.bodySmall),
        const SizedBox(height: 5),
        Text(
          "+92 3467464387",
          style: textTheme.bodySmall?.copyWith(fontWeight: .w600),
        ),
      ],
    );
  }
}
