import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_pc/model/nodo_item.dart';

//import 'package:football_manager/ui/teamScreen.dart';
import 'package:http/http.dart';

class API {
  static Future getChampionships() {
    var url = "http://192.168.1.106:8000/team/championships/";
    return get(url);
  }
}

class ChampionshipsScreen extends StatefulWidget {
  @override
  _ChampionshipsScreenState createState() => new _ChampionshipsScreenState();
}

class _ChampionshipsScreenState extends State<ChampionshipsScreen> {
  var championships = new List<ChampionshipItem>();

  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();

  final String url = 'http://192.168.1.106:8000/team/championships/';

  _getChampionships() {
    API.getChampionships().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        championships =
            list.map((model) => ChampionshipItem.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getChampionships();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new ListView.builder(
        itemCount: championships.length,
        itemBuilder: (context, index) {
          ChampionshipItem c1 = championships[index];
          return new Card(
            color: Colors.white10,
            child: new ListTile(
              title: championships[index],
              onTap: () => this._update(championships[index], index),
              trailing: new Listener(
                key: new Key(championships[index].id.toString()),
                child: new Icon(Icons.remove_circle, color: Colors.red),
                onPointerDown: (pointerEvent) => this._delete(c1.id, index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _getChampionships),
    );
  }

  _delete(int id, int index) async {
    print(id);
    String deleteUrl = this.url + id.toString() + "/";
    Response response = await delete(deleteUrl);
    if (response.statusCode == 204) {
      // TODO: eliminare din lista de championships
      //eliminare din lista
//      this.championships.clear();
      setState(() {
        this.championships.removeAt(index);
      });

      print("delete a avut succcess");
    }
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
    String putUrl = this.url + c.id.toString() + "/";
    _textEditingControllerTM.text = c.totalMatches;
    _textEditingController.text = c.trophy;
    Map<String, String> headers = {"Content-type": "application/json"};

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
            onPressed: () async {
              if (_textEditingController.text != "" &&
                  _textEditingControllerTM.text != "") {
                String json = '{"total_matches":"' +
                    _textEditingControllerTM.text +
                    '" , "trophy": "' +
                    _textEditingController.text +
                    '"}';
                Response response =
                    await put(putUrl, headers: headers, body: json);
                // check the status code for the result
                int statusCode = response.statusCode;
                if (statusCode == 200) {
                  setState(() {
                    var c1 = new ChampionshipItem(_textEditingController.text,
                        _textEditingControllerTM.text);
                    c1.id = c.id;
                    setState(() {
                      championships[index] = c1;
                    });
//                    this._getChampionships();

                    print("&&&&&&&&&&&&&&&&&&&&");
                  });
                  //TODO ramane de updatat lista
                  print("Put cu success");

                  Navigator.pop(context);
                }
              }
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: new Text("Cancel")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
