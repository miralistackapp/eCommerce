import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/screen/product_screen/add_product_screen.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key, required this.product, required this.productController})
      : super(key: key);

  final ProductModel product;
  final ProductController productController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.appWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ColorConstant.appBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  base64Decode(product.productImages.first),
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: AppText(product.productName!, fontWeight: FontWeight.w500,)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => productController.isAdmin.isTrue
                      ? Get.to(() => AddProductScreen(isEdit: true, productId: product.productId))
                      : productController.addToCart(product),
                  child: Icon(
                    productController.isAdmin.isTrue ? Icons.edit : Icons.shopping_cart,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppText(
              product.productDesc!,
              fontSize: 10,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: ColorConstant.appGrey,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    '₹ ${product.productPrice}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: ColorConstant.appGrey,
                  ),
                ),
                Expanded(
                  flex: num.parse(product.productQuantity!) <= 0 ? 2 : 1,
                  child: AppText(
                    num.parse(product.productQuantity!) <= 0 ? 'Out of Stock' : '${product.productQuantity} Pc',
                    maxLines: 1,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: num.parse(product.productQuantity!) <= 0 ? ColorConstant.appRed : ColorConstant.appGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
