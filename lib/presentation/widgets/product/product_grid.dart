import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/widgets/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductGrid extends StatelessWidget {
  final String selectedCategory;
  const ProductGrid({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');
    Query query = productsRef;

    if (selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    final width = MediaQuery.of(context).size.width;
    double childAspectRatio = width < 380 ? 0.52 : 0.62;

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
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
          return Center(
            child: Text(
              "No products found.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final products = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 40),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final productDoc = products[index];
            final data = productDoc.data() as Map<String, dynamic>;
            data['id'] = productDoc.id;
            return ProductCard(data: data);
          },
        );
      },
    );
  }
}
