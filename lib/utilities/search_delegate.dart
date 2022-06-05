import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signly/models/main_category_model.dart';
import 'package:signly/models/sub_category_model.dart';
import 'package:signly/screens/dictionary_main_categories_screen.dart';
import 'package:signly/screens/dictionary_translation_screen.dart';
import 'package:signly/utilities/database_manager.dart';
import '../models/word_model.dart';

class WordsSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Word> matchQuery = [];
    for (var word in DatabaseManager.searchTerms) {
      if (word.word.toLowerCase().contains(query.toLowerCase()) &&
          matchQuery != "") {
        matchQuery.add(word);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, DictionaryTranslationScreen.screenID,
                  arguments: {"currentWord": result, "isSearch": true});
              print("you selected " + result.word);
            },
            child: ListTile(
              title: Text(result.word),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Word> matchQuery = [];
    for (var word in DatabaseManager.searchTerms) {
      if (word.word.toLowerCase().contains(query.toLowerCase()) &&
          matchQuery != "") {
        matchQuery.add(word);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          Word result = matchQuery[index];
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, DictionaryTranslationScreen.screenID,
                  arguments: {"currentWord": result, "isSearch": true});
              print("you selected " + result.word);
            },
            child: ListTile(
              title: Text(result.word),
            ),
          );
        });
  }
}
