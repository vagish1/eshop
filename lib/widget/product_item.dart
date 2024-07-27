import 'package:eshop/product/controller/product_controller.dart';
import 'package:eshop/product/model/product_model.dart';
import 'package:eshop/services/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.products,
  });

  final Products products;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      final productController = context.read<ProductController>();
      productController.updateShowDiscountedPrice(
          b: FirebaeRemote.instance.remoteConfig
              .getBool("showDiscountedPrice"));

      FirebaeRemote.instance.remoteConfig.onConfigUpdated.listen((e) {
        FirebaeRemote.instance.remoteConfig.onConfigUpdated
            .listen((event) async {
          await FirebaeRemote.instance.remoteConfig.activate();
          productController.updateShowDiscountedPrice(
              b: FirebaeRemote.instance.remoteConfig
                  .getBool("showDiscountedPrice"));
          // Use the new config values here.
          debugPrint(productController.showDiscountedPrice.toString());
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 225, 242, 255),
                borderRadius: BorderRadius.circular(12.sp),
                image: DecorationImage(
                  image: NetworkImage(widget.products.images!.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.sp),
            Text(
              "${widget.products.title}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 6.h),
            Text(
              "${widget.products.description}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Consumer<ProductController>(
                    builder: (context, productController, child) {
                  return Container(
                    margin: productController.showDiscountedPrice == false
                        ? EdgeInsets.zero
                        : EdgeInsets.only(top: 2.5.h),
                    child: Text(
                      "\$${widget.products.price}",
                      style: productController.showDiscountedPrice == false
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleSmall!.merge(
                              const TextStyle(
                                  decoration: TextDecoration.lineThrough)),
                    ),
                  );
                }),
                Consumer<ProductController>(
                    builder: (context, productController, child) {
                  return Text(
                    productController.showDiscountedPrice == true
                        ? "\$${(widget.products.price! - (widget.products.discountPercentage! / 100) * widget.products.price!).toStringAsFixed(2)}"
                        : "",
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                }),
                Container(
                  margin: EdgeInsets.only(top: 2.5.h),
                  child: Text(
                    "${widget.products.discountPercentage}% off",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
