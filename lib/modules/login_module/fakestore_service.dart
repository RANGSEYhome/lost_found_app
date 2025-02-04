import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'fakestore_login_models.dart';

enum PostMethod{
  insert,
  update,
  delete,
}

class FakestoreService {
  static Future<MyResponseModel> login(
      {required LoginRequestModel request}) async {
    String url = "https://d-api.devkrc.com/v1/auth/login";
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
    String url = "https://d-api.devkrc.com/v1/auth/sign-up";
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
      if(output["status"] == "success"){
        return "success";
      }else{
        return output.toString();
      }
    } catch (e) {
      throw Exception(e);
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
