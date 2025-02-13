import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_model.dart';



//String api = "http://10.0.2.2:4001/v1";
String api = "https://d-api.devkrc.com/v1";
class PostSeviceRead {
static Future<void> read({
  int page = 1,
  String userId= "1",
  required Function(List<Doc>) onRes,
  required Function(Object?) onError,
}) async {
  String url = "$api/post?page=$page&limit=10"; 
  print("User ID: $userId");
  print("Url: $url");
  if(userId != "1"){
    url = "$api/post?page=$page&limit=10&userId=$userId"; 
  }
  try {
    final response = await http.get(Uri.parse(url));

   // print("Raw API Response: ${response.body}"); // ✅ Print API response

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          final jsonData = json.decode(response.body); // ✅ FIX: Remove explicit type casting
          
          if (jsonData is Map<String, dynamic>) { // ✅ Ensure it's a Map before processing
         //   print("Decoded JSON Data: $jsonData");
            final data = PostGetDataModel.fromJson(jsonData);
             print("Decoded JSON Data: $jsonData");
            onRes(data.docs); 
          } else {
            onError("Unexpected JSON format: Expected a Map, got ${jsonData.runtimeType}");
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

static Future<void> readPage({
  int page = 1,
  required Function(List<Doc>) onRes,
  required Function(Object?) onError,
}) async {
  String url = "$api/post?page=$page&limit=10"; 

  try {
    final response = await http.get(Uri.parse(url));

    //print("Raw API Response: ${response.body}"); // ✅ Print API response

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          final jsonData = json.decode(response.body); // ✅ FIX: Remove explicit type casting
          
          if (jsonData is Map<String, dynamic>) { // ✅ Ensure it's a Map before processing
         //   print("Decoded JSON Data: $jsonData");
            final data = PostGetDataModel.fromJson(jsonData);
             print("Decoded JSON Data: $jsonData");
            onRes(data.docs); 
          } else {
            onError("Unexpected JSON format: Expected a Map, got ${jsonData.runtimeType}");
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
    String url = "$api/post?page=$page&limit=10&query=$query";
    if (query =="") {
      return ;
    }
print("Urls: $url");
    try {
      final response = await http.get(Uri.parse(url));

      // print("Raw API Response: ${response.body}"); // ✅ Print API response

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final jsonData = json
                .decode(response.body); // ✅ FIX: Remove explicit type casting

            if (jsonData is Map<String, dynamic>) {
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

