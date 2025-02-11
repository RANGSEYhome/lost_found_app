// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

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
    String userId;
    String title;
    String description;
    String categoryId;
    String type;
    String location;
    String images;
    String date;
    String status;
    String phone;

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
        required this.status,
        required this.phone,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        categoryId: json["categoryId"],
        type: json["type"],
        location: json["location"],
        images: json["images"],
        date: json["date"],
        status: json["status"],
        phone: json["phone"],

    );

    Map<String, dynamic> toJson() => {
        id: "_id",
        "userId": userId,
        "title": title,
        "description": description,
        "categoryId": categoryId,
        "type": type,
        "location": location,
        "images": images,
        "date": date,
        "status": status,
        "phone": phone,
    };
}

