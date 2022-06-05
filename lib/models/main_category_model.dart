import 'package:signly/models/sub_category_model.dart';

//model for defining main category objects
class MainCategory {
  String categoryName;
  List<SubCategory> subCategories;
  //constructor
  MainCategory({required this.categoryName, required this.subCategories});

  //method that takes a json objects and creates a MainCategory Object
  static MainCategory fromJson(Map<String, dynamic> json) {
    return MainCategory(
        categoryName: json["mainCategory"],
        subCategories: SubCategory.fromJson(json));
  }
}
