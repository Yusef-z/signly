import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signly/models/main_category_model.dart';
import '../models/sub_category_model.dart';
import '../models/word_model.dart';
import '../models/letter_model.dart';

class DatabaseManager {
  static CollectionReference categories =
      FirebaseFirestore.instance.collection("all_categories");
  static List<Letter> allLeters = [];
  static List<MainCategory> allCategoriesData = [];
  static List<Word> searchTerms = [];
  static Map<String, List<SubCategory>> categoriesGroupsMap = {};
  static Map<String, List<String>> categoriesGroupsMapStr = {};
  static int categoryTilesCount = 0;

  //initializing the letters
  static Future<void> initAllLeters() async {
    Stream<List<Letter>> lettersStream = FirebaseFirestore.instance
        .collection("letters")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Letter(
                  letter: doc.data()["letter"],
                  video_path: doc.data()["video_path"]);
            }).toList());
    DatabaseManager.allLeters = await lettersStream.first;
  }
  
  static void initCategoriesGroupsMap() {
    for (MainCategory mainCategory in DatabaseManager.allCategoriesData) {
      DatabaseManager.categoriesGroupsMap[mainCategory.categoryName] =
          mainCategory.subCategories;
      DatabaseManager.categoriesGroupsMapStr[mainCategory.categoryName] = [];
      for (SubCategory subCategory in mainCategory.subCategories) {
        DatabaseManager.categoriesGroupsMapStr[mainCategory.categoryName]!
            .add(subCategory.categoryName);
        categoryTilesCount += 1;
      }
    }
  }

  static void initSearchTerms() {
    for (MainCategory mainCategory in DatabaseManager.allCategoriesData) {
      for (SubCategory subCategory in mainCategory.subCategories) {
        for (Word word in subCategory.allwords) {
          searchTerms.add(word);
        }
      }
    }
  }

  static Stream<List<MainCategory>> getCategories() =>
      FirebaseFirestore.instance
          .collection("all_categories")
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                print("doc id is: " + doc.id);
                return MainCategory.fromJson(doc.data());
              }).toList());

  static Future<List<MainCategory>> getCategoriesList() async =>
      await getCategories().first;
}
