import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/model/orders_model.dart';
import 'package:learning/screen/product_screen/product_screen.dart';
import 'package:learning/screen/product_screen/users_screen.dart';
import 'package:learning/screen/sign_in_screen/sign_in_screen.dart';
import 'package:learning/utils/shared_preference.dart';

class OrdersScreen extends StatelessWidget {
  final controller = Get.find<ProductController>();

  OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appDarkGreen,
          leading: const Icon(Icons.menu),
          title: const AppText(
            'Orders',
            color: ColorConstant.appWhite,
            fontSize: 18,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 26, right: 20, top: 40),
            children: [
              if (controller.isAdmin.isTrue)
                GestureDetector(
                  onTap: () => Get.to(() => ProductScreen()),
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
                  onTap: () => Get.back(),
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
          ),
        ),
        body: SafeArea(
          child: GetBuilder<ProductController>(
            init: ProductController(),
            initState: (state) {
              Future.delayed(
                const Duration(microseconds: 200),
                () {
                  final productController = Get.find<ProductController>();
                  productController.getAllOrders();
                },
              );
            },
            builder: (productController) {
              return productController.ordersList.isEmpty
                  ? const Center(
                      child: AppText(
                        'Oops, No orders available',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 6),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                            itemBuilder: (context, index) {
                              OrdersModel ordersModel = productController.ordersList[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstant.appWhite,
                                  boxShadow: ColorConstant.appBoxShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Order Id : ${ordersModel.orderId!}',
                                      color: ColorConstant.appDarkGreen,
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(color: ColorConstant.appGrey, height: 0.5),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            'Order count : ${ordersModel.orderQuantity!}',
                                            color: ColorConstant.appDarkGreen,
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          child: AppText(
                                            'Order total : ${ordersModel.orderPrice!}',
                                            color: ColorConstant.appDarkGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                            itemCount: productController.ordersList.length,
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
