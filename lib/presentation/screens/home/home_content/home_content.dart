import 'package:drips_water/logic/view_models/product/product_grid_view_model.dart';
import 'package:drips_water/presentation/screens/home/home_content/product_grid.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/category_tile.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/home_app_bar.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/home_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  final List<String> categories = const [
    "All",
    "Distilled",
    "Spring",
    "Purified",
    "Mineral",
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = context.watch<ProductGridViewModel>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const HomeAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const HomeSlider(),

              const SizedBox(height: 32),

              // Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Water Categories",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("See All"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Category List
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => vm.changeCategory(category),
                        child: CategoryTile(
                          text: category,
                          isSelected: vm.categorySelected == category,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Popular Products",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const ProductGrid(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
