import 'package:eshop/product/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {
  List<Products> fetchedProducts = [];

  bool isLoadingProducts = false;
  bool isErrOccuredWhileLoadingProducts = false;
  String errorMessage = "";
  bool showDiscountedPrice = false;
  bool hasInternetConnection = true;

  void updateFetchedProducts({required List<Products> product}) {
    fetchedProducts.clear();
    fetchedProducts.addAll(product);
    notifyListeners();
  }

  void updateIsLoadingProduct({required bool isLoading}) {
    isLoadingProducts = isLoading;
    notifyListeners();
  }

  void updateIsErrorOccuredWhileLoadingProducts({required bool error}) {
    isErrOccuredWhileLoadingProducts = error;
    notifyListeners();
  }

  bool isPaginating = false;
  void updateIsPaginating(bool v) {
    isPaginating = v;
    notifyListeners();
  }

  void addProduct({required List<Products> product}) {
    fetchedProducts.addAll(product);
    notifyListeners();
  }

  void updateShowDiscountedPrice({required bool b}) {
    showDiscountedPrice = b;
    notifyListeners();
  }
}
