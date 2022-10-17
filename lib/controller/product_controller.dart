import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:learning/app/widget/app_toast.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/main.dart';
import 'package:learning/model/cart_model.dart';
import 'package:learning/model/orders_model.dart';
import 'package:learning/model/product_model.dart';
import 'package:learning/model/users_model.dart';
import 'package:learning/screen/product_screen/product_screen.dart';
import 'package:learning/service/db_helper.dart';
import 'package:learning/utils/validation_utils.dart';
import 'package:path_provider/path_provider.dart';

class ProductController extends GetxController {
  RxBool isAdmin = false.obs;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();
  final ImagePicker imagePicker = ImagePicker();
  RxList<String> productsImageList = <String>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<UserModel> usersList = <UserModel>[].obs;
  RxList<OrdersModel> ordersList = <OrdersModel>[].obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController shortDescController = TextEditingController();
  final TextEditingController mfgDateController = TextEditingController();

  Future<void> getAllProducts() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    isAdmin.value = uid == 'G44QhSPw55N7fToPvT4UNI3nQcu2';
    refresh();
    productList.clear();
    List<Map<String, dynamic>> productsList = await DBHelper.instance.getAllProducts();
    for (Map<String, dynamic> element in productsList) {
      ProductModel productModel = ProductModel.fromJson(element);
      String imageFile = await File(productModel.productImage!).readAsString();
      if (imageFile.isNotEmpty) {
        productModel.productImages = productImagesFromJson(imageFile);
        productList.add(productModel);
      }
    }
    refresh();
  }

  Future<void> getAllUsers() async {
    usersList.value = await DBHelper.instance.getAllUsers();
    usersList.removeWhere((element) => element.userId == 'G44QhSPw55N7fToPvT4UNI3nQcu2');
    update();
  }

  Future<void> getAllOrders() async {
    ordersList.value = await DBHelper.instance.getAllOrders();
    update();
  }

  void changeCategory(String? request) {
    selectedCategory = request;
    refresh();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
      helpText: 'Select MFG date',
      confirmText: 'Okay',
      cancelText: 'Cancel',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: ColorConstant.appWhite,
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.appBlue,
              onSurface: ColorConstant.appLightBlack,
            ),
            fontFamily: 'intern',
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      mfgDateController.text = formatter.format(picked);
    }
  }

  void productImages() async {
    List<XFile>? productImage = await imagePicker.pickMultiImage(imageQuality: 100);
    if (productImage.isNotEmpty) {
      for (XFile element in productImage) {
        List<int> imageBytes = File(element.path).readAsBytesSync();
        productsImageList.add(base64Encode(imageBytes));
      }
      update();
    }
  }

  void removeImage(int index) {
    productsImageList.removeAt(index);
    update();
  }

  Future<void> validateProductForm(bool isEdit, num? id) async {
    if (ValidationUtils.validateEmptyController(nameController)) {
      'Product name can\'t be empty'.showToast(isError: true);
    } else if (selectedCategory == null) {
      'Please, Select category'.showToast(isError: true);
    } else if (ValidationUtils.validateEmptyController(priceController)) {
      'Product price can\'t be empty'.showToast(isError: true);
    } else if (ValidationUtils.validateEmptyController(quantityController)) {
      'Product quantity can\'t be empty'.showToast(isError: true);
    } else if (productsImageList.isEmpty) {
      'Please, Select product image'.showToast(isError: true);
    }  else if (ValidationUtils.validateEmptyController(shortDescController)) {
      'Product short description can\'t be empty'.showToast(isError: true);
    } else if (ValidationUtils.validateEmptyController(mfgDateController)) {
      'Please, Select MFG date'.showToast(isError: true);
    } else {
      ProductModel productModel = ProductModel(
        productName: nameController.text.trim(),
        productCategory: selectedCategory,
        productPrice: priceController.text.trim(),
        productQuantity: quantityController.text.trim(),
        productDesc: shortDescController.text.trim(),
        productMfgDate: selectedDate.toLocal().toIso8601String(),
      );
      if (isEdit) {
        productModel.productId = id;
      }
      int productId = isEdit
          ? await DBHelper.instance.updateProduct(productModel)
          : await DBHelper.instance.addProduct(productModel);
      await saveProductImages(isEdit ? id!.toInt() : productId);
      isEdit ? 'Product Updated successfully'.showToast() : 'Product added successfully'.showToast();
      nameController.clear();
      selectedCategory = null;
      priceController.clear();
      productsImageList.clear();
      quantityController.clear();
      shortDescController.clear();
      mfgDateController.clear();
      selectedDate = DateTime.now();
      Get.off(() => ProductScreen());
    }
  }

  Future<String?> saveProductImages(int productId) async {
    Directory directory = await getApplicationSupportDirectory();
    Directory savedLocation = await Directory('${directory.absolute.path}/Products').create(recursive: true);
    File file = File('${savedLocation.path}/$productId.txt');
    String fileData = productImagesToJson(productsImageList);
    await file.writeAsString(fileData);
    int bytes = file.lengthSync();
    logs('File size --> ${(bytes / 1048576).toStringAsFixed(2)}');
    await DBHelper.instance.updateProductById(productId, DBHelper.productImage, file.path);
    logs('File path --> ${file.path}');
    return file.path;
  }

  Future<void> addToCart(ProductModel product) async {
    if (num.parse(product.productQuantity!) <= 0) {
      'Out of Stock'.showToast(isError: true);
      return;
    }
    List<CartModel> cartList = await DBHelper.instance.getMyCartMap();
    CartModel existCartModel = cartList.firstWhere(
      (element) => element.cartProductId == product.productId,
      orElse: () => CartModel(
        cartProductPrice: num.parse(product.productPrice!),
        cartProductQuantity: 1,
      ),
    );
    CartModel cartModel = CartModel(
      cartProductId: product.productId,
      cartProductPrice: num.parse(product.productPrice!),
      cartProductQuantity: existCartModel.cartProductQuantity,
      cartProductTotal: num.parse(product.productPrice!) * existCartModel.cartProductQuantity,
    );
    if (existCartModel.cartProductId != null) {
      cartModel.cartProductQuantity += 1;
      DBHelper.instance.updateCartById(existCartModel.cartProductId!, DBHelper.cartProductQuantity, cartModel.cartProductQuantity);
      'Product quantity updated to cart.!'.showToast();
    } else {
      DBHelper.instance.addCartProduct(cartModel);
      'Product added to cart.!'.showToast();
    }
  }

  Future<void> getProductDetails(num? productId) async {
    ProductModel productModel = await DBHelper.instance.getProductById(productId!);
    logs('Product model --> ${productModel.toJson()}');
    nameController.text = productModel.productName!;
    selectedCategory = productModel.productCategory!;
    priceController.text = productModel.productPrice!;
    quantityController.text = productModel.productQuantity!;
    shortDescController.text = productModel.productDesc!;
    mfgDateController.text = DateFormat('dd MMMM yyyy').format(DateTime.parse(productModel.productMfgDate!));
    String imageFile = await File(productModel.productImage!).readAsString();
    if (imageFile.isNotEmpty) productsImageList.value = productImagesFromJson(imageFile);
    update();
  }
}
