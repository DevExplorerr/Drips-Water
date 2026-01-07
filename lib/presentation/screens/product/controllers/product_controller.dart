import 'package:drips_water/data/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class ProductController extends ChangeNotifier {
  final ProductModel product;

  ProductController(this.product) {
    selectedSize = product.sizes.first;
  }

  late String selectedSize;
  int quantity = 1;

  int get selectedPrice => product.pricePerSize[selectedSize]!;

  void changeSize(String size) {
    selectedSize = size;
    notifyListeners();
  }
}
