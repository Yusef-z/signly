import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/widgets/rounded_button.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/app_bottom_navbar.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);
  static String screenID = "contact_us_screen";
  //text controllers to manage user input
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  //Asynchronous method to be used for sending emails
  Future<void> sendingEmail() async {
    //creating the email object
    final Email email = Email(
      body: bodyController.text,
      subject: subjectController.text,
      recipients: ["yusefzarzar@gmail.com"],
      attachmentPaths: [],
      isHTML: false,
    );

    String platformResponse;

    try {
      //Sending the email
      await FlutterEmailSender.send(email);
      //changing response
      platformResponse = 'success';
    } catch (error) {
      //error handling
      print(error);
      platformResponse = error.toString();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1(headerText: "Contact us", verticalPadding: 0),
              SizedBox(
                height: 15,
              ),
              Text(
                "Subject",
                style: kH2Styling,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: subjectController,
                onChanged: (value) {
                  subjectController.text = value;
                  subjectController.selection = TextSelection.fromPosition(
                      TextPosition(offset: subjectController.text.length));
                },
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(150, 144, 123, 230),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Body",
                style: kH2Styling,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: bodyController,
                onChanged: (value) {
                  bodyController.text = value;
                  bodyController.selection = TextSelection.fromPosition(
                      TextPosition(offset: bodyController.text.length));
                },
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                minLines: 10,
                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(150, 144, 123, 230),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: RoundedButton(
                  buttonText: "Send Email",
                  onPressed: () async {
                    await sendingEmail();
                  },
                  buttonWidth: 200,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(color: Colors.white, thickness: 3),
              Text(
                "Application Developers",
                style: kH2Styling,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Yousef Ali Zarzar - 19423382",
                style: kH2Styling.copyWith(fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Mohammed Wahba - 19420289",
                style: kH2Styling.copyWith(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
