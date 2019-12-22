import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:football_pc/model/nodo_item.dart';

//import 'package:football_manager/ui/teamScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  var championships = new List<ChampionshipItem>();

  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();

  final String url = 'http://192.168.1.106:8000/team/championships/';

  _getChampionships() async {
    championships.forEach((elem) async {
      if (elem.id == -250) {
        Map<String, String> headers = {"Content-type": "application/json"};
        String jsonDict = '{"total_matches":"' +
            elem.totalMatches +
            '" , "trophy": "' +
            elem.trophy +
            '"}';
        // make POST request
        await post(url, headers: headers, body: jsonDict);
      }
    });
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
          onPressed: _showFormDialog),
    );
  }

  _delete(int id, int index) async {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
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
      } else {
        Fluttertoast.showToast(
            msg: "Delete unavailable with no internet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      // No-Internet Case
    });
  }

  _handleSubmitted(String text, String textTwo) async {
    var c = new ChampionshipItem(text, textTwo);
    check().then((intenet) async {
      if (intenet != null && intenet) {
        Map<String, String> headers = {"Content-type": "application/json"};
        String jsonDict = '{"total_matches":"' +
            _textEditingControllerTM.text +
            '" , "trophy": "' +
            _textEditingController.text +
            '"}';
        // make POST request
        Response response = await post(url, headers: headers, body: jsonDict);
        // check the status code for the result
        int statusCode = response.statusCode;
        print("&&&&&&&&&&&&");
        final Map parsed = json.decode(response.body.toString());
        c.id = parsed['id'];

        print(statusCode);
        if (statusCode == 201) {
          setState(() => this.championships.add(c));
          _textEditingController.clear();
          _textEditingControllerTM.clear();

          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Added in local db",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        c.id = -250;
        setState(() => this.championships.add(c));
        _textEditingController.clear();
        _textEditingControllerTM.clear();
        Navigator.pop(context);
      }
    });
  }

  void _showFormDialog() {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        this._getChampionships();
      }
    });

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
    check().then((intenet) async {
      if (intenet != null && intenet) {
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
                        var c1 = new ChampionshipItem(
                            _textEditingController.text,
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
      } else {
        Fluttertoast.showToast(
            msg: "Update unavailable with no internet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
