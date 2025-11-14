// ignore_for_file: deprecated_member_use

import 'package:drips_water/logic/providers/favorite_provider.dart';
import 'package:drips_water/presentation/screens/home/favorite/widgets/favorite_grid.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteIds = favoriteProvider.favorites;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(centerTitle: true, title: const Text("Favorites")),
      body: favoriteIds.isEmpty
          ? AppEmptyState(
              title: "No favorites yet",
              description:
                  "Tap the heart icon on any item to save it here for later.",
              icon: Icons.favorite_border,
            )
          : FavoriteGrid(favoriteIds: favoriteIds),
    );
  }
}
