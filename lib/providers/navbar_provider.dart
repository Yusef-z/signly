import 'package:flutter/material.dart';
//Navigation Bar Provider to be used for navigation bar state management

class NavBarProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  //method to change the selected tab index 
  void changeSelectedTabIndex(int newIndex) {
    _selectedTabIndex = newIndex;
    notifyListeners();
  }
}
