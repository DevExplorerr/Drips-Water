import 'package:drips_water/logic/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartIconBadge extends StatelessWidget {
  final Color? badgeColor;
  final Color? textColor;
  final Color? iconColor;
  final double? width;
  final double? height;
  final IconData icon;
  final double? left;
  final double? bottom;

  const CartIconBadge({
    super.key,
    required this.badgeColor,
    required this.textColor,
    required this.width,
    required this.height,
    required this.icon,
    this.iconColor,
    this.left,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, __) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: iconColor, size: 25),
            if (cartProvider.totalItems > 0)
              Positioned(
                left: left ?? 15,
                bottom: bottom ?? 15,
                child: Container(
                  width: width,
                  height: height,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cartProvider.totalItems.toString(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
