import 'package:flutter/material.dart';
import 'package:signly/constants.dart';

class CountriesPopupButton extends StatefulWidget {
  late double iconSize;
  Function? onSelected;
  late int initialIndex;

  CountriesPopupButton(
      {required this.iconSize, this.onSelected, required this.initialIndex});

  @override
  State<CountriesPopupButton> createState() => _CountriesPopupButtonState();
}

class _CountriesPopupButtonState extends State<CountriesPopupButton> {
  List<List<String>> values = [
    ["English (United States)", "us"],
    ["English (United Kingdom)", "gb"],
    ["Spanish (Spain)", "es"],
    ["French (France)", "fr"],
    ["German (Germany)", "de"]
  ];

  late List<String> selectedValues;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValues = values[widget.initialIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<List<String>>(
        initialValue: [
          ...(values[widget.initialIndex]),
          widget.initialIndex.toString()
        ],
        padding: EdgeInsets.zero,
        iconSize: widget.iconSize,
        icon: Tab(
          icon: new Image.asset('icons/flags/png/${selectedValues[1]}.png',
              package: 'country_icons'),
        ),
        color: kSecondaryColor,
        onSelected: (List<String> selected) {
          setState(() {
            widget.initialIndex = int.parse(selected[2]);
            selectedValues = values[widget.initialIndex];
            if (widget.onSelected != null) {
              widget.onSelected!(selected);
            }
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<List<String>>>[
          PopupMenuItem<List<String>>(
            value: [...(values[0]), "0"],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    child: Image.asset('icons/flags/png/us.png',
                        package: 'country_icons')),
                Text("English (United States)", style: kContryPopupItemStyle),
              ],
            ),
          ),
          PopupMenuItem<List<String>>(
            value: [...(values[1]), "1"],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    child: Image.asset('icons/flags/png/gb.png',
                        package: 'country_icons')),
                Text(
                  "English (United Kingdom)",
                  style: kContryPopupItemStyle,
                )
              ],
            ),
          ),
          PopupMenuItem<List<String>>(
            value: [...(values[2]), "2"],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    child: Image.asset('icons/flags/png/es.png',
                        package: 'country_icons')),
                Text("Spanish (Spain)", style: kContryPopupItemStyle)
              ],
            ),
          ),
          PopupMenuItem<List<String>>(
            value: [...(values[3]), "3"],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    child: Image.asset('icons/flags/png/fr.png',
                        package: 'country_icons')),
                Text("French (France)", style: kContryPopupItemStyle)
              ],
            ),
          ),
          PopupMenuItem<List<String>>(
            value: [...(values[4]), "4"],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    child: Image.asset('icons/flags/png/de.png',
                        package: 'country_icons')),
                Text("German (Germany)", style: kContryPopupItemStyle)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
