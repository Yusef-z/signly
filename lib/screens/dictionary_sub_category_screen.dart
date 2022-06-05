import 'package:flutter/material.dart';
import 'package:signly/constants.dart';
import 'package:signly/models/sub_category_model.dart';
import 'package:signly/screens/dictionary_translation_screen.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import '../utilities/search_delegate.dart';
import '../models/word_model.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({Key? key}) : super(key: key);
  static String screenID = "sub_category_screen";

  //building the widget tree
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SubCategory;
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                args.categoryName,
                style: kH2Styling,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: args.itemsCount,
                    itemBuilder: (context, index) {
                      Word currentWord = args.allwords[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                            trailing: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    DictionaryTranslationScreen.screenID,
                                    arguments: {
                                      "currentWord": currentWord,
                                      "allWords": args.allwords,
                                      "wordIndex": index,
                                      "isSearch": false
                                    });
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 40,
                              ),
                            ),
                            subtitle:
                                Text(currentWord.translations[0].partOfSpeech),
                            title: Text((index + 1).toString() +
                                ". " +
                                currentWord.word)),
                      );
                    }))
          ],
        ));
  }
}
