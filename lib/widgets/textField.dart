import "package:flutter/material.dart";

class FormTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final Icon? prefixIcon;
  final String hintText;
  final Widget? suffixfixIcon;
  bool obscureText;
  final double topMargin;
  final double bottomMargin;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  FormTextField(
      {this.keyboardType = TextInputType.text,
      required this.hintText,
      this.prefixIcon,
      this.suffixfixIcon,
      this.obscureText = false,
      this.bottomMargin = 0,
      this.topMargin = 0,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin, top: topMargin),
      width: 300,
      child: TextFormField(
        onChanged: (text) {
          controller.text = text;
        },
        validator: validator,
        style: TextStyle(fontSize: 18),
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7))),
          contentPadding: EdgeInsets.only(top: 10, bottom: 0),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 18),
          prefixIcon: prefixIcon,
          suffixIcon: suffixfixIcon,
        ),
      ),
    );
  }
}
