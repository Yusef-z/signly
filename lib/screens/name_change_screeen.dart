import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/constants.dart';
import 'package:signly/models/user_info_model.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/rounded_button.dart';

import '../providers/auth_provider.dart';

class NameChangeScreen extends StatefulWidget {
  NameChangeScreen({Key? key}) : super(key: key);
  static String screenID = "name_change_screen";

  @override
  State<NameChangeScreen> createState() => _NameChangeScreenState();
}

class _NameChangeScreenState extends State<NameChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  //text controllers to manage user input
  TextEditingController newFirstNameController = TextEditingController();

  TextEditingController newLastNameController = TextEditingController();
  //method to update the full name of the user in our database
  void _updateFullName() async {
    try {
      if (newFirstNameController.text == "" ||
          newLastNameController.text == "") {
        //in case both fields are empty an exception  is thrown
        throw Exception("empty-fields");
      }
      User currentUser = FirebaseAuth.instance.currentUser!;
      //updating the database document for this user
      DocumentReference currentUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid);
      currentUserDocument.update({
        "firstName": newFirstNameController.text,
        "lastName": newLastNameController.text
      });

      //updating the AuthProvider currentUserInfo
      currentUserDocument.get().then((value) {
        UserDetails currentUserInfo = UserDetails(
            email: value.get("email"),
            firstName: value.get("firstName"),
            lastName: value.get("lastName"),
            dictLang: value.get("dictLang"));
        Provider.of<AuthProvider>(context, listen: false)
            .changeCurrerntUserInfo(currentUserInfo);
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Full Name Update Successful"),
                content: Text("your full name has been updated sucessfully"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ProfileScreen.screenID, (r) => false);
                      },
                      child: Text('OK'))
                ],
              ));
    } on Exception catch (exception) {
      handleFullNameUpdateError(exception);
      print(exception);
    }
  }

  void handleFullNameUpdateError(Exception exception) {
    String messageToDisplay = "";
    switch (exception.toString()) {
      case "Exception: empty-fields":
        messageToDisplay = "Please fill all the required fields";
        break;
      default:
        print("error code is: " + exception.toString());
        messageToDisplay = "unknown error occured";
        break;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Full Name Update Failed"),
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
                "First name: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: newFirstNameController,
                onChanged: (value) {
                  newFirstNameController.text = value;
                  newFirstNameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: newFirstNameController.text.length));
                  print(newFirstNameController.text);
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
                "Last name: ",
                style: kH2Styling.copyWith(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: newLastNameController,
                onChanged: (value) {
                  newLastNameController.text = value;
                  newLastNameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: newLastNameController.text.length));
                  print(newLastNameController.text);
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
                          _updateFullName();
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
