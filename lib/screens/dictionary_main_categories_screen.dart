import 'package:flutter/material.dart';
import 'package:signly/screens/dictionary_sub_category_screen.dart';
import 'package:signly/utilities/database_manager.dart';
import 'package:signly/utilities/search_delegate.dart';
import 'package:signly/widgets/app_bottom_navbar.dart';
import '../constants.dart';
import '../models/sub_category_model.dart';

class MainCategoriesScreen extends StatelessWidget {
  const MainCategoriesScreen({Key? key}) : super(key: key);
  static String screenID = "main_categorries_screen";
  //a method that returns a list of widgets to be used in the widget tree
  List<Widget> categoriesTileBuilder(BuildContext context) {
    List<Widget> resultantTiles = [];
    //going over all the main categories
    for (String mainCategory
        in DatabaseManager.categoriesGroupsMap.keys.toList()) {
      //going overr all the sub categories
      for (int i = 0;
          i < DatabaseManager.categoriesGroupsMap[mainCategory]!.length;
          i++) {
        //getting the current sub category
        SubCategory subCategory =
            DatabaseManager.categoriesGroupsMap[mainCategory]![i];
        //adding a new widget to the resulltantTiles
        resultantTiles.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            trailing: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SubCategoryScreen.screenID,
                    arguments: subCategory);
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 40,
              ),
            ),
            subtitle: Text(mainCategory),
            title: Text(subCategory.categoryName),
            leading: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  "assets/Icons/" + subCategory.iconFile,
                  fit: BoxFit.contain,
                ),
              ),
              radius: 25,
            ),
          ),
        ));
      }
    }
    return resultantTiles;
  }

  //building the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      bottomNavigationBar: AppBottomNavBar(),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
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
              "Categories",
              style: kH2Styling,
            ),
          ),
          Expanded(
            child: ListView(
              children: categoriesTileBuilder(context),
            ),
          )
        ],
      ),
    );
  }
}
