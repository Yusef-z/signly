import 'package:flutter/material.dart';
import 'package:signly/constants.dart';

class H1 extends StatelessWidget {
  String headerText;
  double verticalPadding;
  H1({required this.headerText, required this.verticalPadding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Text(
        headerText,
        style: kH1Styling,
      ),
    );
  }
}
