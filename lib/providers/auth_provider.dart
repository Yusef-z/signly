import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signly/models/user_info_model.dart';

//Authintication Provider to be used for widget state management
class AuthProvider with ChangeNotifier {
  late User _currentUser;

  late UserDetails _currentUserInfo;
  User get currentUser => _currentUser;
  UserDetails get currentUserInfo => _currentUserInfo;
  //method to change the value of currentUserInfo
  void changeCurrerntUserInfo(UserDetails newUserInfo) {
    _currentUserInfo = newUserInfo;
    notifyListeners();
  }

  //method to change the value of the current user
  void changeUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }
}
