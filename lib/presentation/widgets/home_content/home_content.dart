import 'package:drips_water/presentation/widgets/home_content/home_app_bar.dart';
import 'package:drips_water/presentation/widgets/home_content/home_slider.dart';
import 'package:drips_water/presentation/widgets/home_content/water_category_tile.dart';
import 'package:drips_water/presentation/widgets/product/product_grid.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const HomeAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 50),
            physics: const BouncingScrollPhysics(),
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      WaterCategoryTile(color: Color(0xff212121), text: "All"),
                      SizedBox(width: 12),
                      WaterCategoryTile(
                        color: Color(0x99212121),
                        text: "Distilled",
                      ),
                      SizedBox(width: 12),
                      WaterCategoryTile(
                        color: Color(0x99212121),
                        text: "Spring",
                      ),
                      SizedBox(width: 12),
                      WaterCategoryTile(
                        color: Color(0x99212121),
                        text: "Purified",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ProductGrid(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
