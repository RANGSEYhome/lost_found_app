import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';

//String api = "http://10.0.2.2:4001/v1";

String api = "https://d-api.devkrc.com/v1";
class PostSeevice {
  static Future<String> insert(Doc post) async {
    print("Post: $post");
    String url = "$api/post"; // Replace with your actual API endpoint
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(post.toJson()), // Encode the Doc object to JSON
      );

      final output = json.decode(response.body);
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

  static Future<String> update(Doc post, String id) async {
    // String key = "d033e22ae348aeb5660fc2140aec35850c4da997";
    String url = "$api/post/$id";
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(post.toJson()), // Encode the Doc object to JSON
      );

      final output = json.decode(response.body);
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

static Future<String> updateStatus(String id, String status) async {
  String url = "$api/post/$id"; // Update the endpoint if necessary
  try {
    // Use http.put or http.patch for updating the status
    http.Response response = await http.delete(
      Uri.parse(url),
      body: json.encode({"status": status}), // Send the new status in the request body
      headers: {"Content-Type": "application/json"}, // Set the content type
    );

    final output = json.decode(response.body);
    debugPrint("output: $output");

    if (output["status"] == "success") {
      return "success";
    } else {
      return output.toString();
    }
  } catch (e) {
    debugPrint("Error updating status: $e");
    throw Exception(e);
  }
}

  static Future<void> read({
    int page = 1,
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "$api/post?page=$page&limit=10";

    try {
      final response = await http.get(Uri.parse(url));

      // print("Raw API Response: ${response.body}"); // ✅ Print API response

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final jsonData = json
                .decode(response.body); // ✅ FIX: Remove explicit type casting

            if (jsonData is Map<String, dynamic>) {
              // ✅ Ensure it's a Map before processing
              //   print("Decoded JSON Data: $jsonData");
              final data = PostGetDataModel.fromJson(jsonData);
              print("Decoded JSON Data: $jsonData");
              onRes(data.docs);
            } else {
              onError(
                  "Unexpected JSON format: Expected a Map, got ${jsonData.runtimeType}");
            }
          } catch (jsonError) {
            onError("JSON Decoding Error: $jsonError");
          }
        } else {
          onError("Error: Empty response body.");
        }
      } else {
        onError("HTTP Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      onError("Request Failed: $e");
    }
  }
    static Future<void> search({
    int page = 1,
    String query = "",
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "$api/post?page=$page&limit=10";

    try {
      final response = await http.get(Uri.parse(url));

      // print("Raw API Response: ${response.body}"); // ✅ Print API response

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final jsonData = json
                .decode(response.body); // ✅ FIX: Remove explicit type casting

            if (jsonData is Map<String, dynamic>) {
              // ✅ Ensure it's a Map before processing
              //   print("Decoded JSON Data: $jsonData");
              final data = PostGetDataModel.fromJson(jsonData);
              print("Decoded JSON Data: $jsonData");
              onRes(data.docs);
            } else {
              onError(
                  "Unexpected JSON format: Expected a Map, got ${jsonData.runtimeType}");
            }
          } catch (jsonError) {
            onError("JSON Decoding Error: $jsonError");
          }
        } else {
          onError("Error: Empty response body.");
        }
      } else {
        onError("HTTP Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      onError("Request Failed: $e");
    }
  }
}
