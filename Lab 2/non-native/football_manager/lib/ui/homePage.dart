import 'package:flutter/material.dart';
import 'championshipsScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//
//  List<Computer> _list = <Computer>[];
//  var databaseHelper = DbHelper();
//
//  @override
//  void initState() {
//    super.initState();
//    _readFromDb();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ChampionshipsScreen(),
    );
  }
}
//
//
//_readFromDb() async {
//  List items = await databaseHelper.getItems();
//  setState(() {
//    items.forEach((item) {
//      this._list.add(Computer.map(item));
//    });
//  });
//}
