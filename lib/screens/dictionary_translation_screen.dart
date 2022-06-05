import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/constants.dart';
import 'package:signly/providers/auth_provider.dart';
import 'package:signly/providers/menu_provider.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import 'package:signly/widgets/countries_popup_button.dart';
import 'package:signly/widgets/dictionary_top_nvr_bar.dart';
import 'package:signly/widgets/video_player_controller.dart';
import "package:signly/widgets/top_app_bar.dart";
import 'package:signly/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import '../models/word_model.dart';
import '../utilities/search_delegate.dart';
import '../models/translation_model.dart';

class DictionaryTranslationScreen extends StatefulWidget {
  static String screenID = "dictionaryTranslationScreen";

  @override
  State<DictionaryTranslationScreen> createState() =>
      _DictionaryTranslationScreenState();
}

class _DictionaryTranslationScreenState
    extends State<DictionaryTranslationScreen> {
  @override
  void initState() {
    super.initState();
    if (!(FirebaseAuth.instance.currentUser!.isAnonymous)) {
      Provider.of<MenuProvider>(context, listen: false).changeSelectedIndex(
          Provider.of<AuthProvider>(context, listen: false)
              .currentUserInfo
              .dictLang);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Word currentWord = args["currentWord"] as Word;
    bool isSearch = args["isSearch"] as bool;
    // final int wordIndex = args["wordIndex"] as int;
    // final List<Word> subCategoryAllWords = args["allWords"] as List<Word>;

    //returning the widget trrerre
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(),
      backgroundColor: Color(0xFF333333),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        title: Text(
          "Signly",
          style: kH2Styling,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: WordsSearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isSearch
                ? Container()
                : DictionaryTopNavBar(
                    currentWord: currentWord,
                    subCategoryAllWords: args["allWords"] as List<Word>,
                    wordIndex: args["wordIndex"] as int,
                  ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CountriesPopupButton(
                            initialIndex:
                                FirebaseAuth.instance.currentUser!.isAnonymous
                                    ? 0
                                    : Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .currentUserInfo
                                        .dictLang,
                            iconSize: 80,
                            onSelected: (List<String> selected) {
                              setState(() {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .changeSelectedIndex(
                                        int.parse(selected[2]));
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                currentWord
                                    .translations[Provider.of<MenuProvider>(
                                            context,
                                            listen: false)
                                        .selectedIndex]
                                    .translatedWord,
                                style: kTranslatedWordStyle,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                currentWord
                                    .translations[Provider.of<MenuProvider>(
                                            context,
                                            listen: false)
                                        .selectedIndex]
                                    .partOfSpeech,
                                style: kPartOfSpeechStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign",
                    style: kH1Styling,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  NetworkPlayerWidget(
                      controller: VideoPlayerController.network(currentWord
                          .translations[
                              Provider.of<MenuProvider>(context, listen: false)
                                  .selectedIndex]
                          .video_path),
                      key: UniqueKey()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Definition",
                    style: kH1Styling,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  for (String definition in currentWord
                      .translations[
                          Provider.of<MenuProvider>(context, listen: false)
                              .selectedIndex]
                      .defintion)
                    Text(
                      "◙ " + definition,
                      style: kH1Styling.copyWith(fontSize: 22),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
