import "package:flutter/material.dart";
import 'package:signly/constants.dart';

class GradientRoundedButton extends StatelessWidget {
  final String buttonText;
  final double bottomMargin;
  final double topMargin;
  final VoidCallback onPressed;
  GradientRoundedButton(
      {required this.buttonText,
      this.bottomMargin = 0,
      this.topMargin = 0,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin, top: topMargin),
      width: 300,
      child: RaisedButton(
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: kSecondaryGradient,
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            constraints: const BoxConstraints(
                minWidth: 88.0,
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
