import 'dart:convert';
import 'package:exames_29a/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FovoritesPage extends StatefulWidget {
  List<Model> _favorites;

  FovoritesPage(List<Model> favorites) {
    _favorites = favorites;
  }

  @override
  _FovoritesPageState createState() => _FovoritesPageState(_favorites);
}

class _FovoritesPageState extends State<FovoritesPage> {
  List<Model> _favorites;

  _FovoritesPageState(List<Model> favorites) {
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
                      _favorites[index].status,
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
                      _favorites[index].power.toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showPostLoan();
            },
          ),
        ],
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

  _showPostLoan() {
    _textEditingControllerLoan.clear();
    var alert = new AlertDialog(
      content: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(
                child: new TextField(
              controller: _textEditingControllerLoan,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Id",
              ),
            )),
          ]),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _postReq(_textEditingControllerLoan.text);
            },
            child: Text("Free"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _postReq(id) async {
    String jsonDict = '{"id":' + id + '}';
    Map<String, String> headers = {"Content-type": "application/json"};
    print(jsonDict);
    Response response = await post('http://192.168.1.104:2029/free',
        headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode != 200) {
      final Map parsed = json.decode(response.body.toString());
      print(parsed['text']);
    } else {
      setState(() {
        _favorites.removeWhere((a) => a.id == int.parse(id));
      });
    }
  }
}
