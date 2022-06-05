import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signly/constants.dart';
import 'package:signly/screens/sign_in_screen.dart';
import 'package:signly/widgets/gradient_container.dart';
import 'package:signly/widgets/gradient_rounded_button.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/widgets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String screenID = "sign_up_screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  //text controller to manage user input
  final _firstNameControlller = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var loading = false;
  var obscureText = true;

  void handleSignUpError(FirebaseAuthException exception) {
    String messageToDisplay;
    switch (exception.code) {
      case 'email-already-in-use':
        messageToDisplay = "This email already exists as a user";
        break;
      case 'invalid-email':
        messageToDisplay = "This email is invalid, please try again";
        break;
      case 'operration-not-allowed':
        messageToDisplay = "This operation is not allowed";
        break;
      case 'weak-password':
        messageToDisplay = "This password is too weak";
        break;
      default:
        messageToDisplay = "Unknown Error";
        break;
    }
    setState(() {
      loading = false;
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Sign up failed"),
              content: Text(messageToDisplay),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                )
              ],
            ));
  }

  //building the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GradientContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              H1(headerText: "Create an Account", verticalPadding: 0),
              FormTextField(
                validator: requiredValidator,
                controller: _firstNameControlller,
                topMargin: 23,
                bottomMargin: 23,
                hintText: "First Name",
                prefixIcon: Icon(
                  Icons.assignment_ind_rounded,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              FormTextField(
                validator: requiredValidator,
                controller: _lastNameController,
                bottomMargin: 23,
                hintText: "Last Name",
                prefixIcon: Icon(
                  Icons.assignment_ind_rounded,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              FormTextField(
                validator: requiredValidator,
                controller: _emailController,
                bottomMargin: 23,
                hintText: "Email Address",
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: Color(0xFFAAAAAA),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              FormTextField(
                validator: requiredValidator,
                controller: _passwordController,
                bottomMargin: 23,
                hintText: "Password",
                suffixfixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    Icons.visibility,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xFFAAAAAA),
                ),
                obscureText: obscureText,
              ),
              if (loading) ...[Center(child: CircularProgressIndicator())],
              if (!loading) ...[
                GradientRoundedButton(
                    buttonText: "Sign up",
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        _signUp();
                      }
                    })
              ],
              Container(
                padding: EdgeInsets.only(top: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account? ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignInScreen.screenID);
                      },
                      child: Text(
                        "sign in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[400],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //method to sign the user up
  Future _signUp() async {
    setState(() {
      loading = true;
    });
    try {
      //creating the account and saving user credentials 
      UserCredential userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      //saving the user information to the database
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user?.uid)
          .set({
        'email': _emailController.text,
        'firstName': _firstNameControlller.text,
        'lastName': _lastNameController.text,
        "dictLang": 0
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sign up successful"),
                content: Text("Your account was created, please sign in"),
                actions: [
                  TextButton(
                      onPressed: () {
                        loading = false;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(SignInScreen.screenID);
                      },
                      child: Text('OK'))
                ],
              ));
    } on FirebaseAuthException catch (exception) {
      handleSignUpError(exception);
    }
  }
}
