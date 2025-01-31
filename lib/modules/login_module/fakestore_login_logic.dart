import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'fakestore_service.dart';
import 'fakestore_login_models.dart';

class FakestoreLoginLogic extends ChangeNotifier {
  MyResponseModel _responseModel = MyResponseModel();
  MyResponseModel get responseModel => _responseModel;

  final _cache = FlutterSecureStorage();
  final _key = "FakestoreLoginLogic";

  Future read() async {
    String? tk = await _cache.read(key: _key);
    debugPrint("reading token: $tk");
    _responseModel = MyResponseModel(token: tk);
    notifyListeners();
  }

  Future clear() async {
    _cache.delete(key: _key);
    debugPrint("token cleared");
    _responseModel = MyResponseModel(token: null);
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future<MyResponseModel> login(String username, String password) async {
    _loading = true;
    notifyListeners();

    LoginRequestModel requestModel = LoginRequestModel(
      username: username.trim(),
      password: password.trim(),
    );

    try {
      _responseModel = await FakestoreService.login(request: requestModel);
      debugPrint("Saving token: ${_responseModel.token}");
      await _cache.write(key: _key, value: _responseModel.token);
      _error = null;
    } catch (err) {
      _error = err;
      _responseModel = MyResponseModel(token: null, errorText: err.toString());
    }

    _loading = false;
    notifyListeners();
    return _responseModel;
  }

  // Future<MyResponseModel> login(String username, String password) async {

  //   final Completer<MyResponseModel> completer = Completer<MyResponseModel>();

  //   LoginRequestModel requestModel = LoginRequestModel(
  //     username: username.trim(),
  //     password: password.trim(),
  //   );

  //   await FakestoreService.login(
  //     request: requestModel,
  //     onRes: (value) async {
  //       _responseModel = await value;
  //       debugPrint("saving: _key: $_key, _responseModel.token: ${_responseModel.token}");
  //       _cache.write(key: _key, value: _responseModel.token);
  //       _error = null;
  //       _loading = false;
  //       notifyListeners();
  //       completer.complete(_responseModel);
  //     },
  //     onError: (err) {
  //       _error = err;
  //       _loading = false;
  //       notifyListeners();
  //       completer.complete(MyResponseModel(token: null, errorText: err.toString()));
  //     },
  //   );
  //   return completer.future;
  // }
}
