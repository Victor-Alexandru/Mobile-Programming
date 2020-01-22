import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exames_29a/API/ModelApi.dart';
import 'package:exames_29a/model/model.dart';
import 'package:exames_29a/pages/favorites.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';

class ClientPage extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ClientPageApp('User Page'),
    );
  }
}

class ClientPageApp extends StatefulWidget {
  ClientPageApp(String title) {
    this.title = title;
  }

  String title;

  @override
  _ClientPageAppState createState() => _ClientPageAppState();
}

class _ClientPageAppState extends State<ClientPageApp> {
  final String url = "http://192.168.1.104:2029/places";
  List<Model> models = new List<Model>();
  List<Model> _favorites = new List<Model>();
  List<String> _logs = new List<String>();


  final TextEditingController _textEditingControllerLoan =
      new TextEditingController();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Widget ModelCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        // final snackBar = SnackBar(content: Text("Tap"));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ChampionshipDetailPage(
        //             championships[index], url, championships, index)));
      },
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
                      models[index].name,
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
                      models[index].type,
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
                      models[index].power.toString(),
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
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _getModel();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showPostLoan();
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FovoritesPage(_favorites)));
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) => ModelCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    _getModel();
  }

  _getModel() {
    this.check().then((internet) async {
      if (internet != null && internet) {
        ModelAPI.getModels(url).then((response) {
          setState(() {
            print(response.body);
            Iterable list = json.decode(response.body);
            this.models.clear();
            models = list.map((model) => Model.fromJson(model)).toList();
          });
        });
      } else {
        Toast.show("Client get places works only with network", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
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
            child: Text("Take"))
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
    Response response = await post('http://192.168.1.104:2029/take',
        headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode != 200) {
      final Map parsed = json.decode(response.body.toString());
      _logs
          .add(' Bad code  ' + response.statusCode.toString() + parsed['text']);
      Toast.show(parsed['text'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      _logs.add(' Success delete  ' + response.statusCode.toString());
      Model m;
      for (int i = 0; i < models.length; i++) {
        if (models[i].id == int.parse(id)) {
          m = models[i];
        }
      }
      _favorites.add(m);
      print(_favorites.toString());
    }
    print(_logs.toString());
  }
}
