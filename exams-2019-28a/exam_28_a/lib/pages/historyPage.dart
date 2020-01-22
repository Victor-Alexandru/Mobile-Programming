import 'dart:convert';

import 'package:exam_28_a/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HistoryPage extends StatefulWidget {
  List<Model> _favorites;

  HistoryPage(List<Model> favorites) {
    _favorites = favorites;
  }

  @override
  _HistoryPageState createState() => _HistoryPageState(_favorites);
}

class _HistoryPageState extends State<HistoryPage> {
  List<Model> _favorites;

  _HistoryPageState(List<Model> favorites) {
    _favorites = favorites;
  }

  final TextEditingController _textEditingControllerLoan =
      new TextEditingController();

  Widget ModelCell(BuildContext ctx, int index) {
    return GestureDetector(
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      _favorites[index].name,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      _favorites[index].type,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      _favorites[index].size,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      _favorites[index].status,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.navigate_next, color: Colors.black38),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: <Widget>[],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) => ModelCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
