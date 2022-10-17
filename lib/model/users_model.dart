import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.userId,
    this.userEmail,
    this.userName,
  });

  String? userId;
  String? userEmail;
  String? userName;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        userEmail: json["userEmail"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userEmail": userEmail,
        "userName": userName,
      };
}
