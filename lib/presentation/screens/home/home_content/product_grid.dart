import 'package:drips_water/logic/view_models/product/product_grid_view_model.dart';
import 'package:drips_water/presentation/widgets/card/product_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productGridViewModel = context.watch<ProductGridViewModel>();

    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;

    if (productGridViewModel.isLoading) {
      return const ProductCardLoadingIndicator();
    }

    if (productGridViewModel.products.isEmpty) {
      return AppEmptyState(
        title: "No Products Found",
        description:
            "We can't find any items in this section right now. Check out other categories!",
        icon: Icons.inventory_2_outlined,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: productGridViewModel.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final doc = productGridViewModel.products[index];
        final data = doc.data();
        data['id'] = doc.id;
        return ProductCard(data: data);
      },
    );
  }
}
