import 'package:flutter/material.dart';

// will work on navigation logic after login
class NavigationLogic extends ChangeNotifier {
  int _currentIndex = 0; // Default tab index

  int get currentIndex => _currentIndex; // Getter for current index

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify UI about index change
  }
}