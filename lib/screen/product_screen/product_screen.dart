import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/screen/cart_screen/cart_screen.dart';
import 'package:learning/screen/product_screen/add_product_screen.dart';
import 'package:learning/screen/product_screen/orders_screen.dart';
import 'package:learning/screen/product_screen/product_view.dart';
import 'package:learning/screen/product_screen/users_screen.dart';
import 'package:learning/screen/sign_in_screen/sign_in_screen.dart';
import 'package:learning/utils/shared_preference.dart';

class ProductScreen extends StatelessWidget {
  final controller = Get.put(ProductController());

  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appDarkGreen,
          leading: const Icon(Icons.menu),
          title: const AppText(
            'View product',
            color: ColorConstant.appWhite,
            fontSize: 18,
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            cartButtonView(),
          ],
        ),
        drawer: Drawer(
          child: Obx(() {
            return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 26, right: 20, top: 40),
              children: [
                if (controller.isAdmin.isTrue)
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      margin: const EdgeInsets.only(top: 44),
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ColorConstant.appGrey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Products',
                        style: TextStyle(
                          color: ColorConstant.appDarkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (controller.isAdmin.isTrue)
                  GestureDetector(
                    onTap: () => Get.to(() => UsersScreen()),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ColorConstant.appGrey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Users',
                        style: TextStyle(
                          color: ColorConstant.appDarkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (controller.isAdmin.isTrue)
                  GestureDetector(
                    onTap: () => Get.to(() => OrdersScreen()),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ColorConstant.appGrey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Orders',
                        style: TextStyle(
                          color: ColorConstant.appDarkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Get.offAll(() => const SignInScreen());
                    setPrefBoolValue(isLoggedIn, false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ColorConstant.appGrey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: ColorConstant.appDarkGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        body: SafeArea(
          child: GetBuilder<ProductController>(
            init: ProductController(),
            initState: (state) {
              Future.delayed(
                const Duration(microseconds: 200),
                    () {
                  final productController = Get.find<ProductController>();
                  productController.getAllProducts();
                },
              );
            },
            builder: (productController) {
              return productController.productList.isEmpty
                  ? const Center(
                child: AppText(
                  'Oops, No products available',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
                  : Column(
                children: [
                  const SizedBox(height: 6),
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4 / 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 15,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                        productController.productList.length,
                            (index) {
                          ProductModel product = productController.productList[index];
                          return ProductView(
                            product: product,
                            productController: productController,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Obx(() {
          return controller.isAdmin.isTrue
              ? FloatingActionButton(
            backgroundColor: ColorConstant.appDarkGreen,
            onPressed: () => Get.to(() => const AddProductScreen()),
            child: const Icon(Icons.add),
          )
              : const SizedBox();
        }),
      ),
    );
  }

  Obx cartButtonView() {
    return Obx(() {
      return InkWell(
        onTap: () => Get.to(() => const CartScreen()),
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Icons.shopping_cart,
            color: controller.isAdmin.isTrue ? ColorConstant.appDarkGreen : ColorConstant.appWhite,
            size: 20,
          ),
        ),
      );
    });
  }
}
