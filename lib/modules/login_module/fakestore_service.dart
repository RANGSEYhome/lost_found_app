import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'fakestore_login_models.dart';

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
