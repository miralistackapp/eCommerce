import 'dart:convert';

List<OrdersModel> ordersModelFromJson(String str) => List<OrdersModel>.from(json.decode(str).map((x) => OrdersModel.fromJson(x)));

String ordersModelToJson(List<OrdersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersModel {
  OrdersModel({
    this.orderId,
    this.orderPrice,
    this.orderQuantity,
  });

  String? orderId;
  num? orderPrice;
  num? orderQuantity;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        orderId: json["orderId"],
        orderPrice: json["orderPrice"],
        orderQuantity: json["orderQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderPrice": orderPrice,
        "orderQuantity": orderQuantity,
      };
}
