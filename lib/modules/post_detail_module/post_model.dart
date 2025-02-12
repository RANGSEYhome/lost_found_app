// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';

PostModel postModelFromJson(dynamic jsonData) {
  if (jsonData is String) {
    jsonData = json.decode(jsonData); // Decode only if it's a String
  }
  return PostModel.fromJson(jsonData); // Convert to PostModel
}


String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
    List<Doc> docs;
    int totalDocs;
    int limit;
    int totalPages;
    int page;
    int pagingCounter;

    PostModel({
        required this.docs,
        required this.totalDocs,
        required this.limit,
        required this.totalPages,
        required this.page,
        required this.pagingCounter,
    });

    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
    );

    Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
    };
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

  // ✅ Add this toJson method to convert the object into a JSON-friendly format
  Map<String, dynamic> toJson() {
    return {
      "userId": userId.id, // Extract only the user ID string
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

  factory Doc.fromJson(Map<String, dynamic> json) {
    return Doc(
      id: json["_id"] ?? "",
      userId: UserModel.fromJson(json["userId"]),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      categoryId: json["categoryId"] ?? "",
      type: json["type"] ?? "",
      location: json["location"] ?? "",
      images: json["images"] ?? "",
      date: json["date"] ?? "",
      phone: json["phone"] ?? "",
      status: json["status"] ?? "",
    );
  }
}

