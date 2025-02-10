import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_model.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/post_detail_module/post_service_read.dart';


class PostLogic extends ChangeNotifier {
  List<Doc> _postModel = [];
  List<Doc> get postModel => _postModel;

  bool _loading = true; // Set loading to true initially
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }
 Future readAppend(page) async{
    
    await PostSeviceRead.readPage(
    page: page,
    onRes: (items) async {
      print("Items Received: $items"); // ✅ Print received items

      _postModel += items; // No need to await, it's already a List<Doc>
      _loading = false;
      notifyListeners();
    },
    onError: (err) {
      _error = err;
      _loading = false;
      notifyListeners();
    },
  );
  }
  Future read() async {
  await PostSeviceRead.read(
    onRes: (items) async {
      print("Items Received: $items"); // ✅ Print received items

      _postModel = items; // No need to await, it's already a List<Doc>
      _loading = false;
      notifyListeners();
    },
    onError: (err) {
      _error = err;
      _loading = false;
      notifyListeners();
    },
  );
}

}

