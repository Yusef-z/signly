import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signly/constants.dart';
import 'package:signly/main.dart';
import 'package:signly/providers/navbar_provider.dart';
import 'package:signly/screens/dictionary_main_categories_screen.dart';
import 'package:signly/screens/home_screen.dart';
import 'package:signly/screens/profile_screen.dart';
import 'package:signly/screens/text_to_sign_screen.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 30,
      elevation: 4,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      onTap: (index) {
        Provider.of<NavBarProvider>(context, listen: false)
            .changeSelectedTabIndex(index);
        switch (index) {
          case 0:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => HomeScreen(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MainCategoriesScreen(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProfileScreen(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            break;
          default:
            break;
        }
      },
      currentIndex: Provider.of<NavBarProvider>(context).selectedTabIndex,
      selectedItemColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: kSecondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Dictionary",
            backgroundColor: kSecondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: kSecondaryColor),
      ],
    );
  }
}
