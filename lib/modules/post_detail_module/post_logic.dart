import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_model.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/post_detail_module/post_service_read.dart';


class PostLogic extends ChangeNotifier {
  List<Doc> _postModel = [];
  List<Doc> get postModel => _postModel;
  List<Doc> _postGetModel = [];
  List<Doc> get postGetModel => _postGetModel;
  List<Doc> _postSearchModel = [];
  List<Doc> get postSearchModel => _postSearchModel;
  List<Doc> _postSearchCagetoryModel = [];
  List<Doc> get postSearchCagetoryModel => _postSearchCagetoryModel;

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
Future searchByCategory(query, category) async {
  await PostSeviceRead.search(
    query: query,
    category: category,
    onRes: (items) async {
      print("Items Received: $items"); // ✅ Print received items

      _postSearchCagetoryModel = items; // No need to await, it's already a List<Doc>
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

  Future search(query) async {
  await PostSeviceRead.search(
    query: query,
    onRes: (items) async {
      print("Items Received: $items"); // ✅ Print received items

      _postSearchModel = items; // No need to await, it's already a List<Doc>
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
  Future readByUser(String userId) async {
  await PostSeviceRead.read(
    userId: userId,
    onRes: (items) async {
     

      _postGetModel = items; // No need to await, it's already a List<Doc>
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

