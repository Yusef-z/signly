import 'word_model.dart';

//model for creating Subcategory objects
class SubCategory {
  String categoryName;
  int? itemsCount;
  List<Word> allwords;
  String iconFile;
  //constructorr
  SubCategory(
      {required this.allwords,
      required this.categoryName,
      required this.iconFile}) {
    itemsCount = allwords.length;
  }

  //method that takes a json object and creates a SubCategory objects
  static List<SubCategory> fromJson(Map<String, dynamic> json) {
    List<dynamic> subCategoriesJson = json["subCategories"];
    return subCategoriesJson
        .map((subCategory) => SubCategory(
            allwords: Word.fromJson(subCategory),
            categoryName: subCategory["category"],
            iconFile: subCategory["iconFile"]))
        .toList();
  }
}
