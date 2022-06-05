import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/models/user_info_model.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/providers/menu_provider.dart';
import 'package:signly/providers/navbar_provider.dart';
import 'package:signly/screens/contact_us_screeen.dart';
import 'package:signly/screens/email_change_screen.dart';
import 'package:signly/screens/getting_started_screen.dart';
import 'package:signly/screens/name_change_screeen.dart';
import 'package:signly/screens/password_change_screen.dart';
import 'package:signly/screens/sign_in_screen.dart';
import 'package:signly/screens/sign_up_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/countries_popup_button.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/constants.dart';
import 'package:signly/widgets/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String screenID = "profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //method to sign the user out
  Future<void> signOutFromAccount() async {
    try {
      //signing out
      await FirebaseAuth.instance.signOut();
      //returning the user to the initial route and clearing the navigation stack
      Navigator.pushNamedAndRemoveUntil(
          context, GettingStartedScreen.screenID, (r) => false);
      //reseting the navbar selected tab index to 0
      Provider.of<NavBarProvider>(context, listen: false)
          .changeSelectedTabIndex(0);
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
    }
  }

  //method to delete account
  void deleteAccount() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("are you sure you want to delete your account?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () async {
                      try {
                        User currentUser = FirebaseAuth.instance.currentUser!;
                        await currentUser.delete();
                        DocumentReference currentUserDocument =
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser.uid);
                        await currentUserDocument.delete();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Account Deletion Sucessful"),
                                  content: Text(
                                      "Your account and information has been deleted"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            GettingStartedScreen.screenID,
                                            (r) => false);
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ));
                      } on FirebaseAuthException catch (exception) {
                        //exception handling
                        handleDeleteErrors(exception);
                      }
                    },
                    child: Text('Yes'))
              ],
            ));
  }

  //method to handle any errors that might come when deleting an account
  void handleDeleteErrors(FirebaseAuthException exception) {
    String messageToDisplay = "";
    switch (exception.code) {
      case "requires-recent-login":
        messageToDisplay = "recent login required";
        break;
      default:
        print("error code is: " + exception.code);
        messageToDisplay = "unknown error occured";
        break;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Account Deletion Failed"),
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
    User? currentUser;
    UserDetails? currentUserInfo;
    if (!(FirebaseAuth.instance.currentUser!.isAnonymous)) {
      currentUser =
          Provider.of<AuthProvider>(context, listen: false).currentUser;
      currentUserInfo =
          Provider.of<AuthProvider>(context, listen: false).currentUserInfo;
    }
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(),
      backgroundColor: Color(0xFF333333),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: kSecondaryColor,
        title: const Text(
          "Signly",
          style: kH2Styling,
        ),
      ),
      body: FirebaseAuth.instance.currentUser!.isAnonymous
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Text(
                    "You're using a temporary account, you can sign up or sign in at any time",
                    style: kH2Styling,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedButton(
                        buttonText: "Sign Up",
                        onPressed: () async {
                          await signOutFromAccount();
                          Navigator.pushNamed(context, SignUpScreen.screenID);
                        },
                        buttonWidth: MediaQuery.of(context).size.width * 0.35,
                      ),
                      RoundedButton(
                        buttonText: "Sign In",
                        onPressed: () async {
                          await signOutFromAccount();
                          Navigator.pushNamed(context, SignInScreen.screenID);
                        },
                        buttonWidth: MediaQuery.of(context).size.width * 0.35,
                      ),
                    ],
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H1(headerText: "Profile Page", verticalPadding: 10),
                  Text(
                    "First Name: ",
                    style: kH2Styling.copyWith(fontSize: 28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentUserInfo!.firstName,
                        style: kH2Styling.copyWith(fontSize: 22),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, NameChangeScreen.screenID);
                        },
                        child: Text(
                          "update",
                          style: kH2Styling.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Last Name: ",
                    style: kH2Styling.copyWith(fontSize: 28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentUserInfo.lastName,
                        style: kH2Styling.copyWith(fontSize: 22),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, NameChangeScreen.screenID);
                        },
                        child: Text(
                          "update",
                          style: kH2Styling.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email Address: ",
                    style: kH2Styling.copyWith(fontSize: 28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentUser!.email!,
                        style: kH2Styling.copyWith(fontSize: 22),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, EmailChangeScreen.screenID);
                        },
                        child: Text(
                          "update",
                          style: kH2Styling.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Password: ",
                    style: kH2Styling.copyWith(fontSize: 28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "********",
                        style: kH2Styling.copyWith(fontSize: 22),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PasswordChangeScreen.screenID);
                        },
                        child: Text(
                          "update",
                          style: kH2Styling.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  H1(headerText: "Settings", verticalPadding: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dicitonary Language: ",
                        style: kH2Styling.copyWith(fontSize: 28),
                      ),
                      CountriesPopupButton(
                        iconSize: 40,
                        onSelected: (List<String> selected) async {
                          DocumentReference currentUserDocument =
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentUser!.uid);
                          currentUserDocument
                              .update({"dictLang": int.parse(selected[2])});
                          Provider.of<AuthProvider>(context, listen: false)
                              .currentUserInfo
                              .dictLang = int.parse(selected[2]);
                          Provider.of<MenuProvider>(context, listen: false)
                              .changeSelectedIndex(int.parse(selected[2]));
                          print(
                              Provider.of<AuthProvider>(context, listen: false)
                                  .currentUserInfo
                                  .dictLang);
                        },
                        initialIndex: currentUserInfo.dictLang,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RoundedButton(
                        buttonText: "Sign Out",
                        onPressed: () {
                          signOutFromAccount();
                        },
                        buttonColor: Colors.redAccent,
                      ),
                      RoundedButton(
                        buttonText: "Delete Account",
                        onPressed: () async {
                          deleteAccount();
                        },
                        buttonColor: Colors.redAccent,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "need help? ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ContactUsScreen.screenID);
                        },
                        child: Text(
                          "contact us",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[400],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
