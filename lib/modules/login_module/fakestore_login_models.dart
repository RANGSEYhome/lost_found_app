import 'dart:convert';

import 'package:flutter/material.dart';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({
    required this.username,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

MyResponseModel loginResponseModelFromJson(String str) {
  MyResponseModel model;
  debugPrint("str: $str");
  try {
    model = MyResponseModel.fromJson(json.decode(str));
  } on FormatException catch (e) {
    model = MyResponseModel.fromErrorText(str);
  }
  return model;
}

String loginResponseModelToJson(MyResponseModel data) =>
    json.encode(data.toJson());

class MyResponseModel {
  String? token;
  String? errorText;

  MyResponseModel({this.token, this.errorText});

  factory MyResponseModel.fromJson(Map<String, dynamic> json) =>
      MyResponseModel(
        token: json["token"],
        errorText: null,
      );

  factory MyResponseModel.fromErrorText(text) => MyResponseModel(
        token: null,
        errorText: null,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };

  @override
  String toString() {
    return 'MyResponseModel(token: $token, errorText: $errorText)';
  }
}
