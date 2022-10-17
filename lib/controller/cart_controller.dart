import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/app/widget/app_toast.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/main.dart';
import 'package:learning/model/cart_model.dart';
import 'package:learning/model/orders_model.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/service/db_helper.dart';

class CartController extends GetxController {
  List<CartModel> cartModelList = <CartModel>[];
  RxBool isLoading = false.obs;

  void updateQuantity(num productId, num quantity, {bool isAdd = true}) {
    if (!isAdd && quantity - 1 == 0) {
      DBHelper.instance.deleteCartProduct(productId);
    } else {
      DBHelper.instance.updateCartById(productId, DBHelper.cartProductQuantity, isAdd ? quantity + 1 : quantity - 1);
    }
    getCartProducts();
    refresh();
  }

  Future<void> getCartProducts() async {
    cartModelList = await DBHelper.instance.getMyCartMap();
    update();
  }

  void checkOutCart(BuildContext context) {
    isLoading = true.obs;
    update();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        isLoading = false.obs;
        update();
        if (isLoading.isFalse) {
          Get.dialog(
            AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: ColorConstant.appWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => proceedCheckOut(),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const AppText(
                          'Success',
                          color: ColorConstant.appWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: ColorConstant.appRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const AppText(
                          'Failure',
                          color: ColorConstant.appWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> proceedCheckOut() async {
    final productController = Get.find<ProductController>();
    int orderPrice = await DBHelper.instance.calculateMyCart();
    int orderQuantity = await DBHelper.instance.countMyCartMap();
    for (CartModel element in cartModelList) {
      logs('Element --> ${element.toJson()}');
        ProductModel productModel = await DBHelper.instance.getProductById(element.cartProductId!);
        await DBHelper.instance.updateProductById(
          element.cartProductId!,
          DBHelper.productQuantity,
          (num.parse(productModel.productQuantity!) - element.cartProductQuantity).toString(),
        );
        await DBHelper.instance.deleteCartProduct(element.cartProductId!);
    }
    OrdersModel orderModel = OrdersModel(
      orderId: 'Ord ${DateTime.now().microsecondsSinceEpoch}',
      orderPrice: orderPrice,
      orderQuantity: orderQuantity,
    );
    await DBHelper.instance.addOrder(orderModel);
    productController.getAllProducts();
    'Your order placed successfully.!'.showToast();
    Get.back();
    Get.back();
  }
}
