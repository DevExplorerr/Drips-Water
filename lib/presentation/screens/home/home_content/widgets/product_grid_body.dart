import 'package:drips_water/presentation/screens/home/home_content/product_grid_viewmodel.dart';
import 'package:drips_water/presentation/widgets/card/product_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridBody extends StatefulWidget {
  final String selectedCategory;
  const ProductGridBody({super.key, required this.selectedCategory});

  @override
  State<ProductGridBody> createState() => ProductGridBodyState();
}

class ProductGridBodyState extends State<ProductGridBody> {
  @override
  void didUpdateWidget(covariant ProductGridBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      context.read<ProductGridViewModel>().loadProducts(
        widget.selectedCategory,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductGridViewModel>();

    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;

    if (vm.isLoading) return const ProductCardLoadingIndicator();

    if (vm.products.isEmpty) {
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
      itemCount: vm.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final doc = vm.products[index];
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductCard(data: data);
      },
    );
  }
}
