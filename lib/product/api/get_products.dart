import 'package:dio/dio.dart';
import 'package:eshop/product/controller/product_controller.dart';
import 'package:eshop/product/model/product_model.dart';

class GetProductsApi {
  GetProductsApi.init();
  static final GetProductsApi instance = GetProductsApi.init();

  getProducts(
      {required int skip, required ProductController productController}) async {
    try {
      if (skip == 0) {
        productController.updateIsLoadingProduct(isLoading: true);
        productController.updateIsErrorOccuredWhileLoadingProducts(
            error: false);
      } else {
        productController.updateIsPaginating(true);
      }

      final Dio ins = Dio();
      final Response response = await ins.get("https://dummyjson.com/products",
          queryParameters: {"skip": skip});

      final ProductModel productModel = ProductModel.fromJson(response.data);
      if (skip == 0) {
        productController.updateIsLoadingProduct(isLoading: false);
        productController.updateIsErrorOccuredWhileLoadingProducts(
            error: false);
        productController.updateFetchedProducts(
            product: productModel.products ?? []);
      } else {
        productController.updateIsPaginating(false);
        productController.addProduct(product: productModel.products ?? []);
      }
    } on DioException catch (err) {
      if (skip == 0) {
        productController.updateIsLoadingProduct(isLoading: false);
        productController.updateIsErrorOccuredWhileLoadingProducts(error: true);
        productController.errorMessage = err.message!;
      } else {
        productController.updateIsPaginating(false);
      }
    }
  }
}
