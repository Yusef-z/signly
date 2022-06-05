import 'package:flutter/material.dart';

final List<DataList> data = <DataList>[
  DataList('Getting Started', <DataList>[
    DataList('MI'),
  ]),
  DataList('Getting Started', <DataList>[
    DataList('MI'),
  ]),
];

class DataList {
  DataList(this.title, [this.children = const <DataList>[]]);

  final String title;
  final List<DataList> children;

  static List<DataList> initCategoryDataList() {
    return [];
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text('Expandable ListView in Flutter'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            DataPopUp(data[index]),
        itemCount: data.length,
      ),
    ));
  }
}

class DataPopUp extends StatelessWidget {
  const DataPopUp(this.popup);

  final DataList popup;

  Widget _buildTiles(DataList root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<DataList>(root),
      title: Text(
        root.title,
        style: TextStyle(color: Colors.white),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}
