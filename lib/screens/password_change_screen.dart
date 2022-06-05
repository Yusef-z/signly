import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class PasswordChangeScreen extends StatefulWidget {
  PasswordChangeScreen({Key? key}) : super(key: key);
  static String screenID = "password_change_screen";

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  //text editing controllers to manage user input
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  //method that handles exceptions regarding password update
  void handlePasswordUpdateError(FirebaseAuthException exception) {
    String messageToDisplay = "";
    switch (exception.code) {
      case "empty-fields":
        messageToDisplay = "Please fill all the required fields";
        break;
      case "new-password-not-matching":
        messageToDisplay =
            "the confirmation of the new password is not matching, please try again";
        break;
      case "requires-recent-login":
        messageToDisplay = "recent login required";
        break;
      case "wrong-password":
        messageToDisplay = "incorrect password given, please try again";
        break;
      case "weak-password":
        messageToDisplay =
            "password is too weak, it should be atleast 6 characters long";
        break;
      default:
        messageToDisplay = "unknown error occured";
        break;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Password Update Failed"),
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

  //method for updating the password of the current user from database
  void _updatePassword() async {
    try {
      if (currentPasswordController.text == "" ||
          newPasswordController.text == "" ||
          confirmNewPasswordController.text == "") {
        //in case the fields are empty
        throw FirebaseAuthException(code: "empty-fields");
      }
      if (newPasswordController.text != confirmNewPasswordController.text) {
        //in case new password and its confirmation are not equal
        throw FirebaseAuthException(code: "new-password-not-matching");
      }
      //getting the current user from the AuthProvider
      User currentUser =
          Provider.of<AuthProvider>(context, listen: false).currentUser;
      //getting currentCredentials
      AuthCredential currentCredential = EmailAuthProvider.credential(
          email: currentUser.email!, password: currentPasswordController.text);
      //ensuring the correctness of the previous password
      await currentUser.reauthenticateWithCredential(currentCredential);
      //updating the password
      await currentUser.updatePassword(newPasswordController.text);
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Password Update Successful"),
                content: Text("your password has been updated sucessfully"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ProfileScreen.screenID, (r) => false);
                      },
                      child: Text('OK'))
                ],
              ));
      User? updatedUser = FirebaseAuth.instance.currentUser;
      //updating the user of AuthProvider
      Provider.of<AuthProvider>(context, listen: false)
          .changeUser(updatedUser!);
    } on FirebaseAuthException catch (exception) {
      //exception handling
      handlePasswordUpdateError(exception);
    }
  }

  //building the widget tree
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "current password: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: currentPasswordController,
                onChanged: (value) {
                  currentPasswordController.text = value;
                  currentPasswordController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: currentPasswordController.text.length));
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(144, 123, 230, 0.588),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "new password: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: newPasswordController,
                onChanged: (value) {
                  newPasswordController.text = value;
                  newPasswordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: newPasswordController.text.length));
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(150, 144, 123, 230),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "confirm new password: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: confirmNewPasswordController,
                onChanged: (value) {
                  confirmNewPasswordController.text = value;
                  confirmNewPasswordController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: confirmNewPasswordController.text.length));
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(150, 144, 123, 230),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: RoundedButton(
                      buttonWidth: 180,
                      buttonText: "Change",
                      onPressed: () async {
                        _updatePassword();
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
