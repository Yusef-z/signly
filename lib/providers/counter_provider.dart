import 'package:flutter/material.dart';

//Translation Provider to be used for widget state management
class TranslationProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  bool _isTranslating = false;
  bool get isTranslating => _isTranslating;
  //method to be used for switching the value of isTranslating
  void toggleTranslation() {
    _isTranslating = !_isTranslating;
    notifyListeners();
  }
  //method to change the value of isTranslating
  void changeTranslationStatus(bool newTranslationStatus) {
    _isTranslating = newTranslationStatus;
    notifyListeners();
  }

  //method to increment the counterr
  void increment() {
    _counter++;
    notifyListeners();
  }

  //method to reset the counter
  void reset() {
    _counter = 0;
    notifyListeners();
  }
}
