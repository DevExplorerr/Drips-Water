import 'package:cached_network_image/cached_network_image.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/product/widgets/product_option_section.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductBottomSheet extends StatelessWidget {
  final ProductModel product;
  final double price;
  final String image;
  final int quantity;
  final String selectedSize;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;
  const ProductBottomSheet({
    super.key,
    required this.product,
    required this.image,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.onQuantityChanged,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      showDragHandle: false,
      onClosing: () {
        Navigator.pop(context);
      },
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    imageUrl: image,
                    filterQuality: FilterQuality.high,
                    colorBlendMode: BlendMode.darken,
                    placeholder: (context, url) => Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primary,
                        size: 50,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: AppColors.icon,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("\$$price"),
                  Text(selectedSize.toString()),
                  ProductOptionSection(
                    product: product,
                    quantity: quantity,
                    selectedSize: selectedSize,
                    onQuantityChanged: onQuantityChanged,
                    onSizeChanged: onSizeChanged,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
