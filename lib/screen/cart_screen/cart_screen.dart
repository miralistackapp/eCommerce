import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_loader.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/cart_controller.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/main.dart';
import 'package:learning/model/cart_model.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/service/db_helper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return GetBuilder<CartController>(
        init: CartController(),
        initState: (state){
          Future.delayed(
            const Duration(microseconds: 200),
            () {
              final cartController = Get.find<CartController>();
              cartController.getCartProducts();
            },
          );
        },
        builder: (CartController cartController) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ColorConstant.appDarkGreen,
              title: const AppText(
                'Cart product',
                color: ColorConstant.appWhite,
                fontSize: 18,
              ),
              centerTitle: true,
              elevation: 0,
              actions: [checkOutView(context)],
            ),
            body: cartController.isLoading.isTrue
                ? const AppLoader()
                : cartController.initialized && cartController.cartModelList.isNotEmpty
                    ? buildCartProductView()
                    : const Center(
                        child: AppText(
                          'Oops, Your cart is empty.!',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            bottomNavigationBar: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(color: ColorConstant.appDarkGreen),
              child: Row(
                children: [
                  FutureBuilder<int>(
                    future: DBHelper.instance.countMyCartMap(),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Colors.transparent);
                      } else if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: AppText(
                              'Total items : 0',
                              color: ColorConstant.appWhite,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return AppText(
                            'Total items : ${snapshot.data}',
                            color: ColorConstant.appWhite,
                          );
                        } else {
                          return const AppText(
                            'Total items : 0',
                            color: ColorConstant.appWhite,
                          );
                        }
                      } else {
                        return Center(
                          child: AppText(
                            snapshot.connectionState.name,
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  FutureBuilder<int>(
                    future: DBHelper.instance.calculateMyCart(),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Colors.transparent);
                      } else if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: AppText(
                              'Grand Total : 00',
                              color: ColorConstant.appWhite,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return AppText(
                            'Grand Total  : ${snapshot.data}',
                            color: ColorConstant.appWhite,
                          );
                        } else {
                          return const AppText(
                            'Grand Total : 00',
                            color: ColorConstant.appWhite,
                          );
                        }
                      } else {
                        return Center(
                          child: AppText(
                            snapshot.connectionState.name,
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  ListView buildCartProductView() {
    final cartController = Get.find<CartController>();
    return ListView.separated(
      primary: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      itemCount: cartController.cartModelList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        CartModel cartModel = cartController.cartModelList[index];
        return FutureBuilder<ProductModel>(
          future: DBHelper.instance.getProductById(cartModel.cartProductId!),
          builder: (context, AsyncSnapshot<ProductModel> cartProductSnapshot) {
            if (cartProductSnapshot.connectionState == ConnectionState.waiting) {
              return Container(color: Colors.transparent);
            } else if (cartProductSnapshot.connectionState == ConnectionState.active ||
                cartProductSnapshot.connectionState == ConnectionState.done) {
              if (cartProductSnapshot.hasError) {
                return const Center(
                  child: AppText(
                    'Something went wrong',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else if (cartProductSnapshot.hasData) {
                ProductModel? productModel = cartProductSnapshot.data;
                return Container(
                  height: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorConstant.appWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: ColorConstant.appBoxShadow,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.memory(
                              base64Decode(getProductImage(productModel!.productId)),
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              productModel.productName!,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                productPrice(cartModel.cartProductPrice.toString()),
                                const SizedBox(height: 10),
                                productQuantity(cartModel.cartProductQuantity.toString()),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => cartController.updateQuantity(
                                      cartModel.cartProductId!, cartModel.cartProductQuantity),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: ColorConstant.appDarkGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, color: ColorConstant.appWhite, size: 16),
                                  ),
                                ),
                                Expanded(
                                  child: AppText(
                                    '${cartModel.cartProductPrice * cartModel.cartProductQuantity}',
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cartController.updateQuantity(
                                      cartModel.cartProductId!, cartModel.cartProductQuantity,
                                      isAdd: false),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: ColorConstant.appDarkGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove, color: ColorConstant.appWhite, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                );
              } else {
                return const AppText(
                  'No cart data found',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                );
              }
            } else {
              return Center(
                child: AppText(
                  cartProductSnapshot.connectionState.name,
                  fontSize: 20,
                ),
              );
            }
          },
        );
      },
    );
  }

  Row productPrice(String price) {
    return Row(
      children: [
        const AppText('Price', fontSize: 14),
        const Expanded(child: SizedBox()),
        AppText(price, fontSize: 14),
      ],
    );
  }

  Row productQuantity(String quantity) {
    return Row(
      children: [
        const AppText('Quantity', fontSize: 14),
        const Expanded(child: SizedBox()),
        AppText(quantity, fontSize: 14),
      ],
    );
  }

  String getProductImage(num? productId) {
    final productController = Get.find<ProductController>();
    ProductModel productModel = productController.productList.firstWhere((element) => element.productId == productId);
    return productModel.productImages.first;
  }

  InkWell checkOutView(BuildContext context) {
    return InkWell(
      onTap: () {
        final cartController = Get.find<CartController>();
        cartController.checkOutCart(context);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.shopping_cart_checkout_outlined,
          color: ColorConstant.appWhite,
          size: 20,
        ),
      ),
    );
  }
}
