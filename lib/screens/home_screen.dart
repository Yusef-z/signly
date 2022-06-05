import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/constants.dart';
import 'package:signly/providers/counter_provider.dart';
import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/header1.dart';
import 'package:signly/widgets/rounded_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String screenID = "home_screen";
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
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: MediaQuery.of(context).size.height * 0.20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            H1(headerText: "Translations", verticalPadding: 0),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              buttonText: "Text To Sign",
              onPressed: () {
                Navigator.of(context).pushNamed(TextToSignScreen.screenID);
                Provider.of<TranslationProvider>(context, listen: false)
                    .changeTranslationStatus(false);
                Provider.of<TranslationProvider>(context, listen: false)
                    .reset();
              },
              buttonWidth: 220,
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              buttonText: "Sign To Text",
              onPressed: () {},
              buttonWidth: 220,
            )
          ],
        ),
      ),
    );
  }
}
