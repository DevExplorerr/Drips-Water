import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/home/favorite/widgets/empty_state.dart';
import 'package:drips_water/presentation/screens/home/favorite/widgets/favorite_card.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoriteGrid extends StatelessWidget {
  final Set<String> favoriteIds;
  const FavoriteGrid({super.key, required this.favoriteIds});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: favoriteIds.toList())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: AppColors.primary,
              size: 40,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyState();
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 100,
          ),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final data = product.data() as Map<String, dynamic>;
            data['id'] = product.id;
            return FavoriteCard(data: data);
          },
        );
      },
    );
  }
}
