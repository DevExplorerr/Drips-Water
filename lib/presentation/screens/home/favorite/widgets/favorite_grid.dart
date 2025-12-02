import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/presentation/screens/home/favorite/widgets/favorite_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';

class FavoriteGrid extends StatelessWidget {
  final List<String> favorites;
  const FavoriteGrid({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const AppEmptyState(
        title: "No favorites yet",
        description: "Add some products you love",
        icon: Icons.favorite_outline,
      );
    }

    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.58 : 0.64;

    return StreamBuilder<QuerySnapshot>(
      stream: _favoritesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ProductCardLoadingIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const AppEmptyState(
            title: "No favorites yet",
            description: "Add some products you love",
            icon: Icons.favorite_outline,
          );
        }

        final products = snapshot.data!.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
              bottom: 100,
            ),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (_, index) {
              return FavoriteCard(product: products[index]);
            },
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> _favoritesStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: favorites)
        .snapshots();
  }
}
