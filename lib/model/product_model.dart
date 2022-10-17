import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.productId,
    this.productName,
    this.productCategory,
    this.productPrice,
    this.productQuantity,
    this.productImage,
    this.productDesc,
    this.productMfgDate,
    this.productImages = const <String>[],
  });

  num? productId;
  String? productName;
  String? productCategory;
  String? productPrice;
  String? productQuantity;
  String? productImage;
  String? productDesc;
  String? productMfgDate;
  List<String> productImages;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["productId"],
        productName: json["productName"],
        productCategory: json["productCategory"],
        productPrice: json["productPrice"],
        productQuantity: json["productQuantity"],
        productImage: json["productImage"],
        productDesc: json["productDesc"],
        productMfgDate: json["productMfgDate"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "productCategory": productCategory,
        "productPrice": productPrice,
        "productQuantity": productQuantity,
        "productImage": productImage,
        "productDesc": productDesc,
        "productMfgDate": productMfgDate,
      };
}
