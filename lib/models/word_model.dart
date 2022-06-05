import 'translation_model.dart';

//model for creating word objects
class Word {
  String word;
  List<Translation> translations;
  //constructor
  Word({
    required this.word,
    required this.translations,
  });
  //method that takes a json object and creates a SubCategory objects

  static List<Word> fromJson(Map<String, dynamic> json) {
    List<dynamic> wordsJSON = json["all_words"];
    return wordsJSON
        .map((word) =>
            Word(word: word["word"], translations: Translation.fromJson(word)))
        .toList();
  }
}
