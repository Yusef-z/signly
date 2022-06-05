import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/utilities/database_manager.dart';
import 'package:signly/widgets/gradient_rounded_button.dart';
import 'package:signly/widgets/rounded_button.dart';
import 'package:signly/widgets/video_list_controller.dart';
import 'package:signly/widgets/video_player_controller.dart';
import 'package:signly/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import '../providers/counter_provider.dart';
import '../widgets/app_bottom_navbar.dart';
import '../models/word_model.dart';
import 'package:provider/provider.dart';

class TextToSignScreen extends StatefulWidget {
  static String screenID = "text_to_sign_screen";
  const TextToSignScreen({Key? key}) : super(key: key);

  @override
  State<TextToSignScreen> createState() => _TextToSignScreenState();
}

//methid that returns a list of video paths to be used in displaying the videos
List<String> getVideoPaths(List<dynamic> termsObjects) {
  List<String> result = [];
  for (var term in termsObjects) {
    term is Word
        ? result.add(term.translations[0].video_path)
        : result.add(term.video_path);
  }
  return result;
}

//method to be used for getting the text terms value as a list of String
List<String> getTextTerms(Map<String, List<dynamic>> map, String sentence) {
  return getConvertedWords(sentence)["text_terms"] as List<String>;
}

//method to return the RichText widget to be used in displaying the result
Widget getRichTextWidget(List<String> textTerms, BuildContext context) {
  List<InlineSpan> textSpans = [];
  for (int index = 0; index < textTerms.length; index++) {
    String currentTerm = textTerms[index];
    textSpans.add(TextSpan(
        text: currentTerm,
        style:
            Provider.of<TranslationProvider>(context, listen: false).counter ==
                    index
                ? kH2Styling.copyWith(color: Colors.purple)
                : kH2Styling));
  }
  return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Center(child: RichText(text: TextSpan(children: textSpans))));
}

//a methid that takes a sentence and returns a map of useful information after processing the sentence
Map<String, List<dynamic>> getConvertedWords(String sentence) {
  //spliting the given sentence
  List<String> separateWords = sentence.split(" ");
  List<String> textTerms = [];
  List<dynamic> equivalentObjects = [];
  Map<String, List<dynamic>> result = {};
  //iterating on words in sentence
  for (String word in separateWords) {
    Word currentWord;
    //searching for the word in our database
    Iterable<dynamic> queryWords = DatabaseManager.searchTerms
        .where((element) => element.word == word.toLowerCase());
    //in case there is no match
    if (queryWords.length == 0) {
      //iterate over the charachters of the word
      for (int i = 0; i < word.length; i++) {
        String currentChar = word[i];
        //add the current charachter to the equivalentObjects
        equivalentObjects.add(DatabaseManager.allLeters
            .where((element) => element.letter == currentChar.toUpperCase())
            .first);
        //in case the current letter is the last one in the word
        if (i == word.length - 1) {
          currentChar += " ";
        }
        //add current character to the text terms list
        textTerms.add(currentChar);
      }
    }
    //in case a match was found
    else {
      currentWord = queryWords.elementAt(0);
      equivalentObjects.add(currentWord);
      textTerms.add(currentWord.word + " ");
    }
  }
  result["text_terms"] = textTerms;
  result['equivalent_objects'] = equivalentObjects;
  //returning the result
  return result;
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  List<dynamic> termObjects = [];
  List<String> video_paths = [];
  List<String> textTerms = [];
  //text controllers to manage user input
  TextEditingController textToSignController = TextEditingController();
  //building the widget tree
  @override
  Widget build(BuildContext context) {
    int playingIndex = Provider.of<TranslationProvider>(context).counter;
    bool isTranslating =
        Provider.of<TranslationProvider>(context).isTranslating;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
        bottomNavigationBar: AppBottomNavBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !isTranslating
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Text To Sign Converter",
                          style: kH2Styling,
                        ),
                      ),
                    )
                  : Container(),
              !isTranslating
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04),
                      child: TextField(
                        controller: textToSignController,
                        onChanged: (value) {
                          textToSignController.text = value;
                          textToSignController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: textToSignController.text.length));
                          print(textToSignController.text);
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
                    )
                  : Container(),
              !isTranslating
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.15),
                      child: RoundedButton(
                        buttonWidth: 240,
                        buttonText: "Convert",
                        onPressed: () {
                          if (textToSignController.text != "") {
                            setState(() {
                              Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .reset();
                              termObjects =
                                  getConvertedWords(textToSignController.text)[
                                      'equivalent_objects']!;
                              video_paths = getVideoPaths(termObjects);
                              textTerms = getConvertedWords(
                                      textToSignController.text)['text_terms']
                                  as List<String>;
                              Provider.of<TranslationProvider>(context,
                                      listen: false)
                                  .toggleTranslation();
                              textToSignController.text = "";
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Translation Error"),
                                      content: Text(
                                          "Please provide a sentence to translate it"),
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
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        bottomMargin: 20,
                        topMargin: 20,
                      ),
                    )
                  : Container(),
              textTerms.isNotEmpty && isTranslating
                  ? getRichTextWidget(textTerms, context)
                  : Container(),
              termObjects.isNotEmpty &&
                      Provider.of<TranslationProvider>(context).counter !=
                          video_paths.length &&
                      isTranslating
                  ? VideoListPlayerWidget(
                      key: UniqueKey(), video_paths: video_paths)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
