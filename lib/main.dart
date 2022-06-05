import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/models/main_category_model.dart';
import 'package:signly/models/sub_category_model.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/providers/menu_provider.dart';
import 'package:signly/providers/navbar_provider.dart';
import 'package:signly/screens/contact_us_screeen.dart';
import 'package:signly/screens/dictionary_main_categories_screen.dart';
import 'package:signly/screens/dictionary_sub_category_screen.dart';
import 'package:signly/screens/dictionary_translation_screen.dart';
import 'package:signly/screens/email_change_screen.dart';
import 'package:signly/screens/getting_started_screen.dart';
import 'package:signly/screens/home_screen.dart';
import 'package:signly/screens/name_change_screeen.dart';
import 'package:signly/screens/password_change_screen.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/screens/sign_in_screen.dart';
import 'package:signly/screens/sign_up_screen.dart';
import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:signly/utilities/database_manager.dart';
import 'package:signly/widgets/video_player_controller.dart';
import 'widgets/countries_popup_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/counter_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Initialization of categories data
  DatabaseManager.allCategoriesData = await DatabaseManager.getCategoriesList();
  DatabaseManager.initSearchTerms();
  DatabaseManager.initCategoriesGroupsMap();
  await DatabaseManager.initAllLeters();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => TranslationProvider(),
      ),
      ChangeNotifierProvider(create: (_) => NavBarProvider()),
      ChangeNotifierProvider(
        create: (_) => MenuProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signly',
      theme: ThemeData(
          primaryColor: kSecondaryColor,
          fontFamily: GoogleFonts.alegreyaSans().fontFamily),
      initialRoute: GettingStartedScreen.screenID,
      routes: {
        TextToSignScreen.screenID: (context) => TextToSignScreen(),
        SubCategoryScreen.screenID: (context) => SubCategoryScreen(),
        DictionaryTranslationScreen.screenID: (context) =>
            DictionaryTranslationScreen(),
        ProfileScreen.screenID: (context) => ProfileScreen(),
        EmailChangeScreen.screenID: (context) => EmailChangeScreen(),
        PasswordChangeScreen.screenID: (context) => PasswordChangeScreen(),
        ContactUsScreen.screenID: (context) => ContactUsScreen(),
        NameChangeScreen.screenID: (context) => NameChangeScreen(),
        HomeScreen.screenID: (context) => HomeScreen(),
        SignUpScreen.screenID: (context) => SignUpScreen(),
        GettingStartedScreen.screenID: (context) => GettingStartedScreen(),
        SignInScreen.screenID: (context) => SignInScreen(),
        MainCategoriesScreen.screenID: (context) => MainCategoriesScreen(),
      },
    );
  }
}
