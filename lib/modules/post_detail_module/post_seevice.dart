import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lost_found_app/modules/post_detail_module/post_model.dart';



String api = "http://10.0.2.2:4001/v1";

//String api = "https://d-api.devkrc.com/v1";
class PostSeevice {
  static Future<String> insert(Doc post) async {
    // String key = "d033e22ae348aeb5660fc2140aec35850c4da997";
    String url = "$api/post";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(post.toJson()), // Ensure JSON encoding
      );
      final output = json.decode(response.body);
      print("Output: $output");
      debugPrint("output: $output");
      if (output["status"] == "success") {
        return "success";
      } else {
        return output.toString();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
static Future read({
  int page = 1,
  required Function(List<Doc>) onRes,
  required Function(Object?) onError,
}) async {
  String url = "$api/post?page=$page&limit=10"; // Correct API format

  try {
    http.Response response = await http.get(Uri.parse(url)); // Using GET instead of POST

    print("Raw API Response: ${response.body}"); // ✅ Print API response

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body); // Decode JSON

      print("Decoded JSON Data: $jsonData"); // ✅ Print the decoded JSON

      final data = PostModel.fromJson(jsonData); // Convert to PostModel
      onRes(data.docs); // Return list of Docs
    } else {
      onError("Error: ${response.body}");
    }
  } catch (e) {
    onError(e);
  }
}


}

