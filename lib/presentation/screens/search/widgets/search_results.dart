import 'package:drips_water/logic/view_models/product/search_view_model.dart';
import 'package:drips_water/presentation/widgets/card/product_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  final SearchViewModel viewModel;
  const SearchResults({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final double childAspectRatio = MediaQuery.of(context).size.width < 380
        ? 0.52
        : 0.62;

    // Showing Loader while Typing
    if (viewModel.isTyping &&
        viewModel.searchController.text.trim().isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ProductCardLoadingIndicator(),
      );
    }

    // No text typed yet
    if (viewModel.searchController.text.trim().isEmpty) {
      return Center(
        child: Text(
          "Start typing to search products",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // No Results / Empty State
    if (viewModel.filteredProducts.isEmpty) {
      return const AppEmptyState(
        title: "No Products Found",
        description:
            "We couldn't find anything matching your search. Try adjusting your search criteria or a different keyword.",
        icon: Icons.search_off_outlined,
      );
    }

    // Search Grid
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GridView.builder(
        itemCount: viewModel.filteredProducts.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          // final product = viewModel.filteredProducts[index];
          // final data = product.data();
          // data['id'] = product.id;
          return ProductCard(product: viewModel.filteredProducts[index]);
        },
      ),
    );
  }
}
