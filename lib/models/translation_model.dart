//model to create translation objects
class Translation {
  String partOfSpeech;
  String translatedWord;
  List<dynamic> defintion;
  String language;
  String video_path;

  //constructor
  Translation(
      {required this.partOfSpeech,
      required this.translatedWord,
      this.defintion = const [],
      required this.language,
      required this.video_path});
  //method that takes a json object and creates a SubCategory objects

  static List<Translation> fromJson(Map<String, dynamic> json) {
    List<dynamic> translationsJSON = json["translations"];
    return translationsJSON.map((translation) {
      return Translation(
          partOfSpeech: translation["partOfSpeech"],
          translatedWord: translation["translated_word"],
          language: translation["language"],
          video_path: translation["video_path"],
          defintion: translation["defintion"]);
    }).toList();
  }
}
