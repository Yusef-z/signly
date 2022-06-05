import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/constants.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/providers/menu_provider.dart';
import 'package:signly/screens/home_screen.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/screens/sign_in_screen.dart';
import 'package:signly/screens/sign_up_screen.dart';
import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:signly/widgets/gradient_container.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/widgets/gradient_rounded_button.dart';
import 'package:signly/widgets/textField.dart';

class GettingStartedScreen extends StatelessWidget {
  static String screenID = "getting_started_screen";

  //returning the widget tree
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GradientContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Getting Started",
                        style: kH2Styling,
                      ),
                      GradientRoundedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.screenID);
                        },
                        buttonText: "Sign Up",
                        bottomMargin: 23,
                        topMargin: 10,
                      ),
                      GradientRoundedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignInScreen.screenID);
                        },
                        buttonText: "Sign In",
                        bottomMargin: 10,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don’t need an acount? ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () async {
                        UserCredential userCredentials =
                            await FirebaseAuth.instance.signInAnonymously();
                        Provider.of<AuthProvider>(context, listen: false)
                            .changeUser(userCredentials.user!);

                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Sign in successful"),
                                  content: Text(
                                      "you have signed in with a temporary account, welcome."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // loading = false;
                                          Provider.of<MenuProvider>(context,
                                                  listen: false)
                                              .changeSelectedIndex(0);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              HomeScreen.screenID,
                                              (r) => false);
                                        },
                                        child: Text('OK'))
                                  ],
                                ));
                      },
                      child: Text(
                        "continue as a guest.",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
