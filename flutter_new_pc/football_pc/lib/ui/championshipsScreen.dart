import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_pc/model/nodo_item.dart';

//import 'package:football_manager/ui/teamScreen.dart';
import 'package:http/http.dart';

class ChampionshipsScreen extends StatefulWidget {
  @override
  _ChampionshipsScreenState createState() => new _ChampionshipsScreenState();
}

class _ChampionshipsScreenState extends State<ChampionshipsScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();

  final String url = 'http://192.168.1.106:8000/team/championships/';
  List<ChampionshipItem> _list = <ChampionshipItem>[];
  int i = 0;

  Widget listWidget() {
    return FutureBuilder(
      builder: (context, championships) {
        if (championships.connectionState == ConnectionState.none &&
            championships.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return ListView.builder(
          itemCount: championships.data.length,
          itemBuilder: (context, index) {
            ChampionshipItem c1 = championships.data[index];
            return new Card(
              color: Colors.white10,
              child: new ListTile(
                title: _list[index],
                onTap: () => this._update(_list[index], index),
                trailing: new Listener(
                  key: new Key(_list[index].trophy),
                  child: new Icon(Icons.remove_circle, color: Colors.red),
                  onPointerDown: (pointerEvent) =>
                      this._delete(_list[index].id, index),
                ),
              ),
            );
          },
        );
      },
      future: getList(),
    );
  }

  Future<List<ChampionshipItem>> _makeGetRequest() async {
    this._list.clear();
    print(i);
    this.i++;
    // make GET request
    Response response = await get(this.url);
    // sample info available in response
    List<dynamic> list = json.decode(response.body);
    // TODO convert json to object...
    list.forEach((item) {
      ChampionshipItem c = ChampionshipItem.fromJson(item);
      this._list.add(c);
    });
    return this._list;
  }

  Future getList() async {
    List<ChampionshipItem> items = await _makeGetRequest();
    print(items);
    return items;
  }

  @override
  void initState() {
    super.initState();
    //    _makeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: listWidget()
//      new Column(
//        children: <Widget>[
//          new Flexible(
//              child: new ListView.builder(
//                  padding: new EdgeInsets.all(8.0),
//                  reverse: false,
//                  itemCount: _list.length,
//                  itemBuilder: (_, int index) {
//                    return new Card(
//                      color: Colors.white10,
//                      child: new ListTile(
//                        title: _list[index],
//                        onTap: () => this._update(_list[index], index),
//                        trailing: new Listener(
//                          key: new Key(_list[index].trophy),
//                          child:
//                              new Icon(Icons.remove_circle, color: Colors.red),
//                          onPointerDown: (pointerEvent) =>
//                              this._delete(_list[index].id, index),
//                        ),
//                      ),
//                    );
//                  })
//          ),
//          new Divider(
//            height: 1.0,
//          )
//        ],
//      ),
      ,
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: getList
      ),
    );
  }

  _delete(int id, int index) async {
//    var removed = await databaseHelper.delete(id);
//    if (removed != null) {
//      setState(() {
//        _list.removeAt(index);
//      });
//    }
  }

  _handleSubmitted(String text, String textTwo) async {
    var c = new ChampionshipItem(text, textTwo);
//    ChampionshipItem saved = await this.databaseHelper.insertC(c);
//    if (saved != null) {
//      setState(() => this._list.add(c));
//      _textEditingController.clear();
//      _textEditingControllerTM.clear();
//      Navigator.pop(context);
//    }
  }

  void _showFormDialog() {
    _textEditingController.clear();
    _textEditingControllerTM.clear();
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Trophy",
              hintText: "not blank",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTM,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Total Matches",
              hintText: "not blank",
            ),
          )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              if (_textEditingController.text != "" &&
                  _textEditingControllerTM.text != "") {
                _handleSubmitted(
                    _textEditingController.text, _textEditingControllerTM.text);
              }
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: new Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _update(ChampionshipItem c, int index) {
    _textEditingControllerTM.text = c.totalMatches;
    _textEditingController.text = c.trophy;
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Trophy",
              hintText: "not blank",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTM,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Total Matches",
              hintText: "not blank",
            ),
          )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              if (_textEditingController.text != "" &&
                  _textEditingControllerTM.text != "") {
                _handleUpdate(c, index, _textEditingController.text,
                    _textEditingControllerTM.text);
              }
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: new Text("Cancel")),
        new FlatButton(
            onPressed: () => {
//                  Navigator.pop(context),
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => TeamScreen(championshipId: c.id)),
//                  )
                },
            child: new Text("Go to teams"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _handleUpdate(ChampionshipItem c, int index, String t1, String t2) async {
//    var c1 = new ChampionshipItem(t1, t2);
//    c1.id = c.id;
//    var result = await databaseHelper.update(c1);
//    setState(() {
//      if (result != null) {
//        _list[index] = c1;
//      }
//    });
//    _textEditingController.clear();
//    _textEditingControllerTM.clear();
//    Navigator.pop(context);
  }
}
