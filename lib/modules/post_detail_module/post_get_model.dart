import 'dart:convert';

import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';

class PostGetDataModel {
  final List<Doc> docs;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  PostGetDataModel({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory PostGetDataModel.fromJson(Map<String, dynamic> json) {
    return PostGetDataModel(
      docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
      totalDocs: json["totalDocs"],
      limit: json["limit"],
      totalPages: json["totalPages"],
      page: json["page"],
      pagingCounter: json["pagingCounter"],
      hasPrevPage: json["hasPrevPage"],
      hasNextPage: json["hasNextPage"],
      prevPage: json["prevPage"],
      nextPage: json["nextPage"],
    );
  }
}

class Doc {
  String id;
  final UserModel userId;
  final String title;
  final String description;
  final String categoryId;
  final String type;
  final String location;
  final String images;
  final String date;
  final String phone;
  final String status;

  Doc({
    this.id = "",
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.type,
    required this.location,
    required this.images,
    required this.date,
    required this.phone,
    required this.status,
  });

  factory Doc.fromJson(Map<String, dynamic> json) {
    return Doc(
      id: json["_id"],
      userId: UserModel.fromJson(json["userId"]),
      title: json["title"],
      description: json["description"],
      categoryId: json["categoryId"],
      type: json["type"],
      location: json["location"],
      images: json["images"],
      date: json["date"],
      phone: json["phone"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId.toJson(), // Ensure UserModel has a toJson method
        "title": title,
        "description": description,
        "categoryId": categoryId,
        "type": type,
        "location": location,
        "images": images,
        "date": date,
        "phone": phone,
        "status": status,
      };
}

// class UserModel {
//   final String id;
//   final String username;
//   final String firstname;
//   final String lastname;
//   final String email;
//   final String phone;
//   final String profilePic;
//   final String role;
//   final String address;
//   final String createdDate;

//   UserModel({
//     required this.id,
//     required this.username,
//     required this.firstname,
//     required this.lastname,
//     required this.email,
//     required this.phone,
//     required this.profilePic,
//     required this.role,
//     required this.address,
//     required this.createdDate,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json["_id"],
//       username: json["username"],
//       firstname: json["firstname"],
//       lastname: json["lastname"],
//       email: json["email"],
//       phone: json["phone"],
//       profilePic: json["profile_pic"],
//       role: json["role"],
//       address: json["address"],
//       createdDate: json["createdDate"],
//     );
//   }
// }
