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

  factory MyResponseModel.fromJson(Map<String, dynamic> json) =>
      MyResponseModel(
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
}

class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  String password;
  String confirmPassword;
  final String profilePic;
  final String role;
  final String address;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.profilePic,
    required this.role,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      phone: json["phone"],
      password: json["password"] ?? "",
      confirmPassword: json["confirmPassword"] ?? "",
      profilePic: json["profile_pic"],
      role: json["role"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "phone": phone,
        "profile_pic": profilePic,
        "role": role,
        "address": address,
      };
}

// class UserModel {
//   String id;
//   String firstname;
//   String lastname;
//   String email;
//   String phone;
//   String password;
//   String confirmPassword;
//   String profilePic;
//   String role;
//   String address;

//   UserModel({
//     required this.id,
//     required this.firstname,
//     required this.lastname,
//     required this.email,
//     required this.phone,
//     required this.password,
//     required this.confirmPassword,
//     required this.profilePic,
//     required this.role,
//     required this.address,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         id: json["_id"] ?? "",  // Handle null values
//         firstname: json["firstname"] ?? "",
//         lastname: json["lastname"] ?? "",
//         email: json["email"] ?? "",
//         phone: json["phone"] ?? "",
//         password: json["password"] ?? "",
//         confirmPassword: json["confirmPassword"] ?? "",
//         profilePic: json["profile_pic"] ?? "",
//         role: json["role"] ?? "",
//         address: json["address"] ?? "",
//       );

  // Map<String, dynamic> toJson() => {
  //       "_id": id,
  //       "firstname": firstname,
  //       "lastname": lastname,
  //       "email": email,
  //       "password": password,
  //       "confirmPassword": confirmPassword,
  //       "phone": phone,
  //       "profile_pic": profilePic,
  //       "role": role,
  //       "address": address,
  //     };
// }

