import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'fakestore_login_models.dart';

enum PostMethod {
  insert,
  update,
  delete,
}
//String api = "http://10.0.2.2:4001/v1";

String api = "https://d-api.devkrc.com/v1";

class FakestoreService {
  static Future<MyResponseModel> login(
      {required LoginRequestModel request}) async {
    String url = "$api/auth/login";
    debugPrint("Body: ${request.toJson()}");
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/json", // Ensure the server knows it's JSON
        },
        body: jsonEncode(request.toJson()),
      );

      final data = compute(loginResponseModelFromJson, response.body);
      debugPrint("response: ${response.body}");
      debugPrint("Data: $data");
      return data;
    } catch (e) {
      return MyResponseModel(token: null, errorText: e.toString());
    }
  }

  static Future<String> insert(UserModel user) async {
    // String key = "d033e22ae348aeb5660fc2140aec35850c4da997";
    String url = "$api/auth/sign-up";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()), // Ensure JSON encoding
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

  static Future<String> updateUser(UserModel user, String id) async {
    // String key = "d033e22ae348aeb5660fc2140aec35850c4da997";
    String url = "$api/user/$id";
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()), // Ensure JSON encoding
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

  static Future<String?> uploadImage(File imagePath) async {
    final url = Uri.parse(
        "$api/files/upload-single-s3"); // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', url);

      // Attach the file
      var file = await http.MultipartFile.fromPath(
        'file', // This should match your backend key (req.file)
        imagePath.path,
      );
      request.files.add(file);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        print('Upload successful: ${jsonResponse['path']}');
        return jsonResponse['path']; // Return the uploaded image path
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return null; // Return null to indicate failure
      }
    } catch (e) {
      print('🚨 Exception occurred: $e');
      return null;
    }
  }
}
// class FakestoreService {
//   static Future login({
//     required LoginRequestModel request,
//     required Function(Future<MyResponseModel>) onRes,
//     required Function(Object?) onError,
//   }) async {
//     String url = "https://fakestoreapi.com/auth/login";
//     try {
//       http.Response response = await http.post(
//         Uri.parse(url),
//         body: request.toJson(),
//       );
//       final data = compute(loginResponseModelFromJson, response.body);
//       onRes(data);
//       onError(null);
//     } catch (e) {
//       onError(e);
//     }
//   }
// }
