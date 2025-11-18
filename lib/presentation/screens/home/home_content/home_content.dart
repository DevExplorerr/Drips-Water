import 'package:drips_water/logic/view_models/product_grid_view_model.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/home_app_bar.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/home_slider.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/category_tile.dart';
import 'package:drips_water/presentation/screens/home/home_content/product_grid.dart';
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
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        const HomeAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const HomeSlider(),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Water type",
                  style: textTheme.titleSmall?.copyWith(fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => vm.changeCategory(category),

                          child: CategoryTile(
                            text: category,
                            isSelected: vm.categorySelected == category,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const ProductGrid(),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
