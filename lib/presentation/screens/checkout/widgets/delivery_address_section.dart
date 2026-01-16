import 'package:flutter/material.dart';

class DeliveryAddressSection extends StatelessWidget {
  final String name;
  final String fullAddress;
  final String phoneNumber;
  const DeliveryAddressSection({
    super.key,
    required this.name,
    required this.fullAddress,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(name, style: textTheme.bodySmall?.copyWith(fontWeight: .w600)),
        const SizedBox(height: 5),
        Text(fullAddress, style: textTheme.bodySmall),
        const SizedBox(height: 5),
        Text(
          phoneNumber,
          style: textTheme.bodySmall?.copyWith(fontWeight: .w600),
        ),
      ],
    );
  }
}
