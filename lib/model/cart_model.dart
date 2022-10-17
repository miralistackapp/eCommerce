import 'dart:convert';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    this.cartProductId,
    this.cartProductImage = '',
    this.cartProductPrice = 0,
    this.cartProductQuantity = 0,
    this.cartProductTotal = 0,
  });

  num? cartProductId;
  String cartProductImage;
  num cartProductPrice;
  num cartProductQuantity;
  num cartProductTotal;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartProductId: json["cartProductId"],
        cartProductPrice: json["cartProductPrice"],
        cartProductQuantity: json["cartProductQuantity"],
        cartProductTotal: json["cartProductTotal"],
      );

  Map<String, dynamic> toJson() => {
        "cartProductId": cartProductId,
        "cartProductPrice": cartProductPrice,
        "cartProductQuantity": cartProductQuantity,
        "cartProductTotal": cartProductTotal,
      };
}
