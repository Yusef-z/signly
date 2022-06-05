import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:signly/main.dart';
import 'package:signly/models/user_info_model.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/providers/menu_provider.dart';
import 'package:signly/screens/home_screen.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/screens/sign_up_screen.dart';
import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:signly/widgets/gradient_container.dart';
import 'package:signly/widgets/gradient_rounded_button.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/widgets/textField.dart';
import 'package:signly/constants.dart';
import '../providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  static String screenID = "sign_in_screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  //text controllers to manage user input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var obscureText = true;
  //method to sign the user in
  void _signIn() async {
    try {
      //signing in and saving the user credentials
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      Provider.of<AuthProvider>(context, listen: false)
          .changeUser(userCredential.user!);
      //getting the corrospanding document reference for the current user from our database
      DocumentReference currentUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.uid);

      currentUserDocument.get().then((value) {
        //creating a UserDetails object
        UserDetails currentUserInfo = UserDetails(
            email: value.get("email"),
            firstName: value.get("firstName"),
            lastName: value.get("lastName"),
            dictLang: value.get("dictLang"));

        //updating AuthPrrovider current user
        Provider.of<AuthProvider>(context, listen: false)
            .changeCurrerntUserInfo(currentUserInfo);
        //updating MenuPrrovider selected index
        Provider.of<MenuProvider>(context, listen: false)
            .changeSelectedIndex(currentUserInfo.dictLang);
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sign in successful"),
                content: Text(
                    "you have signed into your account successfully, welcome."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.screenID, (r) => false);
                      },
                      child: Text('OK'))
                ],
              ));
    } on FirebaseAuthException catch (exception) {
      //exception handling
      handleSignInError(exception);
    }
  }
  //method to handle any error when signing in
  void handleSignInError(FirebaseAuthException exception) {
    String messageToDisplay = "";
    switch (exception.code) {
      case "wrong-password":
        messageToDisplay = "The given password is incorrect, please try again";
        break;
      case "invalid-email":
        messageToDisplay =
            "The given email is invalid, please enter a valid email";
        break;
      case "user-not-found":
        messageToDisplay = "User not found, you can create a new account?";
        break;
      case "too-many-requests":
        messageToDisplay = "too many requests, please try again later";
        break;
      default:
        messageToDisplay = "unknown error occured";
        print("exception is: " + exception.code);
        break;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Sign in failed"),
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
            H1(headerText: "Sign Into Account", verticalPadding: 0),
            FormTextField(
              validator: requiredValidator,
              controller: _emailController,
              topMargin: 23,
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
            GradientRoundedButton(
                buttonText: "Sign In",
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _signIn();
                  }
                }),
            Container(
              padding: EdgeInsets.only(top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have an account? ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.screenID);
                    },
                    child: Text(
                      "sign up",
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
    ));
  }
}
