import 'package:drips_water/presentation/screens/home/home_content/widgets/home_app_bar.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/home_slider.dart';
import 'package:drips_water/presentation/screens/home/home_content/widgets/water_category_tile.dart';
import 'package:drips_water/presentation/screens/home/home_content/product_grid.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = "All";
  List<String> categories = const [
    "All",
    "Distilled",
    "Spring",
    "Purified",
    "Mineral",
  ];

  void onSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                          onTap: () {
                            onSelectedCategory(category);
                          },
                          child: WaterCategoryTile(
                            text: category,
                            isSelected: selectedCategory == category,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProductGrid(selectedCategory: selectedCategory),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
