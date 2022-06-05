import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/models/user_info_model.dart';
import 'package:signly/providers/auth_provider.dart';

//Menu Provider to be used for widget state management
class MenuProvider with ChangeNotifier {
  late int _selectedIndex;

  int get selectedIndex => _selectedIndex;

  //method to change the value of the selectedIndex
  void changeSelectedIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }
}
