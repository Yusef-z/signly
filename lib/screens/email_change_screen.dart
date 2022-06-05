import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/models/user_info_model.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:signly/widgets/textField.dart';

class EmailChangeScreen extends StatefulWidget {
  EmailChangeScreen({Key? key}) : super(key: key);
  static String screenID = "email_change_screen";

  @override
  State<EmailChangeScreen> createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  //controller to manage user input
  TextEditingController newEmailController = TextEditingController();
  //method to handle the errors that might result from updating the email
  void handleEmailUpdateError(FirebaseAuthException exception) {
    String messageToDisplay = "";
    switch (exception.code) {
      case "email-already-in-use":
        messageToDisplay =
            "This email already exists on our database, please try a different one";
        break;
      case "invalid-email":
        messageToDisplay =
            "The given email is invalid, please enter a valid email";
        break;
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
              title: Text("Email Update Failed"),
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
  //method for upadting email address
  void _updateEmailAddress() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .currentUser
          .updateEmail(newEmailController.text);
      User? updatedUser = FirebaseAuth.instance.currentUser;

      Provider.of<AuthProvider>(context, listen: false)
          .changeUser(updatedUser!);
      print("current email is:  ");
      print(
          Provider.of<AuthProvider>(context, listen: false).currentUser.email);

      DocumentReference currentUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(updatedUser.uid);
      currentUserDocument.update({"email": newEmailController.text});

      currentUserDocument.get().then((value) {
        UserDetails currentUserInfo = UserDetails(
            email: value.get("email"),
            firstName: value.get("firstName"),
            lastName: value.get("lastName"),
            dictLang: value.get("dictLang"));

        print(currentUserInfo.email);
        Provider.of<AuthProvider>(context, listen: false)
            .changeCurrerntUserInfo(currentUserInfo);
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Email Update Successful"),
                content:
                    Text("your email address has been updated sucessfully"),
                actions: [
                  TextButton(
                      onPressed: () {
                        // loading = false;
                        Navigator.pushNamedAndRemoveUntil(
                            context, ProfileScreen.screenID, (r) => false);
                      },
                      child: Text('OK'))
                ],
              ));
    } on FirebaseAuthException catch (exception) {
      handleEmailUpdateError(exception);
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
                "new email address: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: newEmailController,
                onChanged: (value) {
                  newEmailController.text = value;
                  newEmailController.selection = TextSelection.fromPosition(
                      TextPosition(offset: newEmailController.text.length));
                  print(newEmailController.text);
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
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _updateEmailAddress();
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
