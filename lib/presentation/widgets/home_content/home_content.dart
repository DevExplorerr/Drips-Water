import 'package:drips_water/presentation/widgets/home_content/home_app_bar.dart';
import 'package:drips_water/presentation/widgets/home_content/home_slider.dart';
import 'package:drips_water/presentation/widgets/home_content/water_category_tile.dart';
import 'package:drips_water/presentation/widgets/product/product_grid.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> products = const [
    {
      "image": "assets/images/home_screen/water1.png",
      "name": "Drips Spring Water",
      "price": "\$100",
      "rating": 4.8,
      "reviews": 186,
      "description":
          "Refreshing spring water naturally filtered through mineral-rich rocks for a crisp, clean taste.",
      "category": "Spring",
    },
    {
      "image": "assets/images/home_screen/water2.png",
      "name": "Drips Distilled Water",
      "price": "\$50",
      "rating": 4.6,
      "reviews": 132,
      "description":
          "Steam-distilled to absolute purity - perfect for labs, appliances, and medical use.",
      "category": "Distilled",
    },
    {
      "image": "assets/images/home_screen/water3.png",
      "name": "Drips Mineral Water",
      "price": "\$50",
      "rating": 4.7,
      "reviews": 158,
      "description":
          "Infused with essential minerals to keep your body hydrated and energized all day.",
      "category": "Mineral",
    },
    {
      "image": "assets/images/home_screen/water4.png",
      "name": "Drips Purified Water",
      "price": "\$100",
      "rating": 4.9,
      "reviews": 204,
      "description":
          "Ultra-pure, smooth, and naturally balanced - designed for those who value refined hydration.",
      "category": "Purified",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final filteredProducts = selectedCategory == "All"
        ? products
        : products.where((p) => p["category"] == selectedCategory).toList();

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
                    for (final category in [
                      "All",
                      "Distilled",
                      "Spring",
                      "Purified",
                      "Mineral",
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: WaterCategoryTile(
                          text: category,
                          isSelected: selectedCategory == category,
                          onTap: () {
                            setState(() => selectedCategory = category);
                          },
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProductGrid(products: filteredProducts),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
