import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_dropdown_button.dart';
import 'package:learning/app/widget/app_elevated_button.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/app/widget/app_text_form_field.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/product_controller.dart';
import 'package:learning/main.dart';

class AddProductScreen extends StatelessWidget {
  final num? productId;
  final bool isEdit;

  const AddProductScreen({Key? key, this.productId, this.isEdit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Scaffold(
      body: GetBuilder<ProductController>(
        init: ProductController(),
        initState: (state) {
          final productController = Get.find<ProductController>();
          if (isEdit) productController.getProductDetails(productId);
        },
        builder: (ProductController controller) {
          return SafeArea(
            child: ListView(
              primary: true,
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Center(
                  child: AppText(
                    isEdit ? 'Edit product' : 'Add product',
                    color: ColorConstant.appBlue,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  hintText: 'Enter name',
                  controller: controller.nameController,
                ),
                const SizedBox(height: 20),
                AppDropdownButton(
                  hint: 'Select category',
                  value: controller.selectedCategory,
                  dropdownItems: const ['Face-wash', 'Serum', 'Face-Scrub'],
                  onChanged: (String? request) => controller.changeCategory(request),
                ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  hintText: 'Enter price',
                  controller: controller.priceController,
                  isPhone: true,
                  textInputType: const TextInputType.numberWithOptions(),
                ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  hintText: 'Enter quantity',
                  controller: controller.quantityController,
                  isPhone: true,
                  length: 3,
                  textInputType: const TextInputType.numberWithOptions(),
                ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  hintText: 'Upload product images',
                  enabled: true,
                  onTap: () => controller.productImages(),
                ),
                if (controller.productsImageList.isNotEmpty)
                  Container(
                    height: 80,
                    margin: const EdgeInsets.only(top: 20),
                    child: ListView.separated(
                      primary: false,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => controller.removeImage(index),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: ColorConstant.appDarkGreen,
                              boxShadow: ColorConstant.appBoxShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(
                                base64Decode(controller.productsImageList[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemCount: controller.productsImageList.length,
                    ),
                  ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  hintText: 'Enter short desc',
                  controller: controller.shortDescController,
                ),
                const SizedBox(height: 20),
                AppTextFormFiled(
                  enabled: true,
                  hintText: 'Enter MFG date',
                  controller: controller.mfgDateController,
                  onTap: () => controller.selectDate(context),
                ),
                const SizedBox(height: 30),
                AppElevatedButton(
                  onPressed: () => controller.validateProductForm(isEdit, productId),
                  buttonName: isEdit ? 'Update product' : 'Add product',
                  horizontalMargin: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
