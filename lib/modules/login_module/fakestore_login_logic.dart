import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'fakestore_service.dart';
import 'fakestore_login_models.dart';

class FakestoreLoginLogic extends ChangeNotifier {
  MyResponseModel _responseModel = MyResponseModel();
  MyResponseModel get responseModel => _responseModel;

  final _cache = FlutterSecureStorage();
  final _key = "FakestoreLoginLogic";
  final _userKey = "usercache";

  Future<void> read() async {
    String? tk = await _cache.read(key: _key);
    String? userData = await _cache.read(key: _userKey);

    debugPrint("Reading Token: $tk");

    UserModel? user;
  if (userData != null) {
      try {
        user = UserModel.fromJson(jsonDecode(userData));
      } catch (e) {
        debugPrint("Error decoding user data: $e");
      }
    }

    _responseModel = MyResponseModel(token: tk, user: user);
    notifyListeners();
  }

  Future<void> clear() async {
    await _cache.delete(key: _key);
    await _cache.delete(key: _userKey);
    debugPrint("Token cleared");

    _responseModel = MyResponseModel(token: null, user: null);
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<MyResponseModel> login(String email, String password) async {
    setLoading(true);

    LoginRequestModel requestModel = LoginRequestModel(
      email: email.trim(),
      password: password.trim(),
    );
    debugPrint("Email: $email, Password: (hidden)");

    try {
      _responseModel = await FakestoreService.login(request: requestModel);

      if (_responseModel.token != null) {
        debugPrint("Saving Token: ${_responseModel.token}");
        await _cache.write(key: _key, value: _responseModel.token);

        if (_responseModel.user != null) {
          await _cache.write(key: _userKey, value: jsonEncode(_responseModel.user!.toJson()));
        }
      }

      _error = null;
    } catch (err) {
      _error = err;
      _responseModel = MyResponseModel(token: null, user: null, errorText: err.toString());
    }

    setLoading(false);
    return _responseModel;
  }
}
