import 'package:eshop/authentication/firebase/auth.dart';
import 'package:eshop/product/api/get_products.dart';
import 'package:eshop/product/controller/product_controller.dart';
import 'package:eshop/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../product/model/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  int pageNo = 0;
  bool hasFetchedData = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = context.read<ProductController>();
      if (hasFetchedData == false) {
        GetProductsApi.instance
            .getProducts(skip: pageNo, productController: productController);
        hasFetchedData = true;
      }

      scrollController.addListener(() {
        if (scrollController.position.atEdge) {
          bool isBottom = scrollController.position.pixels != 0;
          if (isBottom) {
            pageNo += 1;
            GetProductsApi.instance.getProducts(
                skip: pageNo * 30, productController: productController);
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("E shop"),
        actions: [
          IconButton(
            onPressed: () async {
              await Authentication.instance.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          if (productController.isLoadingProducts) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productController.isErrOccuredWhileLoadingProducts) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Server Error Occurred",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(productController.errorMessage),
                ],
              ),
            );
          }

          if (productController.fetchedProducts.isEmpty) {
            return Center(
              child: Text(
                "No Product Found",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.sp),
                  shrinkWrap: true,
                  itemCount: productController.fetchedProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 340.h,
                  ),
                  itemBuilder: (_, index) {
                    final Products products =
                        productController.fetchedProducts.elementAt(index);
                    return ProductItem(products: products);
                  },
                ),
              ),
              if (productController.isPaginating)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.sp,
                        ),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 24.h,
      ),
    );
  }
}
