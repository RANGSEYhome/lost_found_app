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

  bool _loadingMore = false; // Add loadingMore state
  bool get loadingMore => _loadingMore;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future<void> readAppend(int page) async {
    _loadingMore = true; // Set loadingMore to true when fetching more data
    notifyListeners();

    await PostSeviceRead.readPage(
      page: page,
      onRes: (items) async {
        print("Items Received: $items"); // ✅ Print received items

        _postModel += items; // Append new items to the existing list
        _loadingMore = false; // Set loadingMore to false after fetching
        notifyListeners();
      },
      onError: (err) {
        _error = err;
        _loadingMore = false; // Set loadingMore to false on error
        notifyListeners();
      },
    );
  }

  Future<void> read() async {
    await PostSeviceRead.read(
      onRes: (items) async {
        print("Items Received: $items"); // ✅ Print received items

        _postModel = items; // Replace the list with new items
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

  Future<void> searchByCategory(String query, String category) async {
    await PostSeviceRead.search(
      query: query,
      category: category,
      onRes: (items) async {
        print("Items Received: $items"); // ✅ Print received items

        _postSearchCagetoryModel = items; // Replace the list with new items
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

  Future<void> search(String query) async {
    await PostSeviceRead.search(
      query: query,
      onRes: (items) async {
        print("Items Received: $items"); // ✅ Print received items

        _postSearchModel = items; // Replace the list with new items
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

  Future<void> readByUser(String userId) async {
    await PostSeviceRead.read(
      userId: userId,
      onRes: (items) async {
        _postGetModel = items; // Replace the list with new items
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