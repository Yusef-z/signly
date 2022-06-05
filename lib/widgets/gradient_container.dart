import 'package:flutter/material.dart';
import 'package:signly/constants.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  GradientContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: kMainGradient),
      child: child,
    );
  }
}
