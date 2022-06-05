import 'package:flutter/material.dart';

const TextStyle kContryPopupItemStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w700,
);

const LinearGradient kMainGradient = LinearGradient(
    colors: [Color(0xFF272731), Color(0xFF41626B)],
    begin: Alignment(-1, 1),
    end: Alignment(1, -1));

const LinearGradient kSecondaryGradient = LinearGradient(
    colors: [Color(0xFF41626B), Color(0xFF272731)],
    begin: Alignment(-1, 1),
    end: Alignment(1, -1));

const Color kSecondaryColor = Color(0xFF6442EC);

const Color kPrimaryColor = Color(0xFF26252C);
const TextStyle kTranslatedWordStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 42,
);

const TextStyle kPartOfSpeechStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w400,
  fontSize: 22,
);

const TextStyle kH1Styling = TextStyle(
  color: Colors.white,
  fontSize: 42,
  fontWeight: FontWeight.w600,
);

const TextStyle kH2Styling = TextStyle(
  color: Colors.white,
  fontSize: 32,
  fontWeight: FontWeight.w600,
);

ButtonStyle kDictNavBarButtonStyle =
    ButtonStyle(backgroundColor: MaterialStateProperty.all(kSecondaryColor));

const TextStyle kDictNavBarTextStyle =
    TextStyle(color: Colors.white, fontSize: 15);

String? requiredValidator(String? text) {
  if (text == null || text.trim().isEmpty) {
    return 'this field is required';
  }
  return null;
}
