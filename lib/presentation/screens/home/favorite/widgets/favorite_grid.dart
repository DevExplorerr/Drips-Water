import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/model/product_model.dart';
import 'package:drips_water/presentation/screens/home/favorite/widgets/favorite_card.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:drips_water/presentation/widgets/shared/product_card_loading_indicator.dart';
import 'package:flutter/material.dart';

class FavoriteGrid extends StatelessWidget {
  final List<String> favoriteIds;
  const FavoriteGrid({super.key, required this.favoriteIds});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.58 : 0.64;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: favoriteIds.toList())
          .snapshots(),
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

        final products = snapshot.data!.docs;

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
            itemBuilder: (context, index) {
              final productDoc = products[index];
              final product = ProductModel.fromFirestore(productDoc);
              return FavoriteCard(product: product);
            },
          ),
        );
      },
    );
  }
}
