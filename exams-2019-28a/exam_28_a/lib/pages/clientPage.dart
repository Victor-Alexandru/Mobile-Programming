import 'dart:convert';

import 'package:exam_28_a/API/ModelApi.dart';
import 'package:exam_28_a/model/model.dart';
import 'package:exam_28_a/pages/favorites.dart';
import 'package:exam_28_a/pages/historyPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';
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
  final String url = "http://192.168.1.104:2028/bikes";
  List<Model> models = new List<Model>();
  List<Model> loanedBikes = new List<Model>();
  List<Model> historicalBikes = new List<Model>();
  List<String> _logs = new List<String>();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  final TextEditingController _textEditingControllerLoan =
      new TextEditingController();

  Widget ModelCell(BuildContext ctx, int index) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               GenreSongPage(genres[index], this.favorites)));
      // },
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
                      models[index].size,
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
    var favorite = Icons.favorite;
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
                      builder: (context) => FovoritesPage(loanedBikes)));
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryPage(historicalBikes)));
            },
          )
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
            Iterable list = json.decode(response.body);
            this.models.clear();
            models = list.map((model) => Model.fromJson(model)).toList();
          });
        });
      } else {
        Toast.show("Client get bikes works only with network", context,
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
            child: Text("Loan"))
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
    Response response = await post('http://192.168.1.104:2028/loan',
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
      loanedBikes.add(m);
      print(loanedBikes.toString());
      historicalBikes.add(m);
    }
    print(_logs.toString());
  }
}
