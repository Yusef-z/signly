import "package:flutter/material.dart";
import 'package:signly/constants.dart';
import 'package:signly/screens/dictionary_translation_screen.dart';

import '../models/word_model.dart';

class DictionaryTopNavBar extends StatelessWidget {
  late List<Word> subCategoryAllWords;
  late int wordIndex;
  late Word currentWord;

  DictionaryTopNavBar({
    required this.currentWord,
    required this.subCategoryAllWords,
    required this.wordIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: kSecondaryColor.withAlpha(150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: kDictNavBarButtonStyle,
            onPressed: () {
              if (wordIndex >= 1) {
                wordIndex -= 1;
                currentWord = subCategoryAllWords[wordIndex];
                Navigator.of(context).pop();
                Navigator.pushNamed(
                    context, DictionaryTranslationScreen.screenID,
                    arguments: {
                      "currentWord": currentWord,
                      "wordIndex": wordIndex,
                      "allWords": subCategoryAllWords,
                      "isSearch": false
                    });
              }
            },
            child: Text(
              "Previous",
              style: kDictNavBarTextStyle,
            ),
          ),
          Text(
            "${wordIndex + 1}/${subCategoryAllWords.length}",
            style: kDictNavBarTextStyle,
          ),
          OutlinedButton(
            style: kDictNavBarButtonStyle,
            onPressed: () {
              if (wordIndex < subCategoryAllWords.length - 1) {
                wordIndex += 1;
                currentWord = subCategoryAllWords[wordIndex];
                Navigator.of(context).pop();
                Navigator.pushNamed(
                    context, DictionaryTranslationScreen.screenID,
                    arguments: {
                      "currentWord": currentWord,
                      "wordIndex": wordIndex,
                      "allWords": subCategoryAllWords,
                      "isSearch": false
                    });
              }
            },
            child: Text(
              "Next",
              style: kDictNavBarTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
