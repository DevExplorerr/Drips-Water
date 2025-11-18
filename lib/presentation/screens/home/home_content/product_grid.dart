import 'package:drips_water/logic/view_models/product_grid_view_model.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/product_grid_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final String selectedCategory;
  const ProductGrid({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductGridViewModel()..loadProducts(selectedCategory),
      child: ProductGridBody(selectedCategory: selectedCategory),
    );
  }
}
