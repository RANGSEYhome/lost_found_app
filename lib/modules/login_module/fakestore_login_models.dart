import 'dart:convert';
import 'package:flutter/material.dart';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
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
  String? refreshToken;
  UserModel? user;
  String? errorText;

  MyResponseModel({this.token, this.refreshToken, this.user, this.errorText});

  factory MyResponseModel.fromJson(Map<String, dynamic> json) => MyResponseModel(
        token: json["token"],
        refreshToken: json["refreshToken"],
        user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
        errorText: null,
      );

  factory MyResponseModel.fromErrorText(String text) => MyResponseModel(
        token: null,
        refreshToken: null,
        user: null,
        errorText: text,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return 'MyResponseModel(token: $token, refreshToken: $refreshToken, user: $user, errorText: $errorText)';
  }
}

class UserModel {
  String id;
  String username;
  String firstname;
  String lastname;
  String email;
  String phone;
  String profilePic;
  String role;
  String address;
  String createdDate;
  String updatedDate;

  UserModel({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.role,
    required this.address,
    required this.createdDate,
    required this.updatedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        role: json["role"],
        address: json["address"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "profile_pic": profilePic,
        "role": role,
        "address": address,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
      };

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, firstname: $firstname, lastname: $lastname, email: $email, phone: $phone, role: $role)';
  }
}
