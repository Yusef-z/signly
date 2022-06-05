import "package:flutter/material.dart";
import 'package:signly/constants.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final double bottomMargin;
  final double topMargin;
  final VoidCallback onPressed;
  late Color buttonColor;
  double buttonWidth;
  RoundedButton(
      {required this.buttonText,
      this.bottomMargin = 0,
      this.topMargin = 0,
      required this.onPressed,
      this.buttonWidth = 0,
      this.buttonColor = kSecondaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin, top: topMargin),
      child: RaisedButton(
        color: buttonColor,
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Ink(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            constraints: BoxConstraints(
                maxWidth: buttonWidth != 0 ? buttonWidth : double.infinity,
                minHeight: 36.0), // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
