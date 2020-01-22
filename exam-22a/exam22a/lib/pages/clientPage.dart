import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:exam22a/api/modelApi.dart';
import 'package:exam22a/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class ClientPage extends StatelessWidget {
  // This widget is the root of your application.
  List<String> _logs = new List();
  ClientPage(List<String> logs) {
    _logs = logs;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ClientPageApp('User Page', _logs),
    );
  }
}

class ClientPageApp extends StatefulWidget {
  List<String> _logs = new List();

  ClientPageApp(String title, List<String> logs) {
    this.title = title;
    _logs = logs;
  }

  String title;

  @override
  _ClientPageAppState createState() => _ClientPageAppState(_logs);
}

class _ClientPageAppState extends State<ClientPageApp> {
  final String url = "http://192.168.1.104:2201/low";
  List<Model> models = new List<Model>();
  List<Model> _favorites = new List<Model>();
  ProgressDialog progressDialog;
  List<String> _logs = new List();
  _ClientPageAppState(List<String> logs) {
    _logs = logs;
  }

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
                      models[index].details,
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
                      models[index].rating.toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _makePostReq(models[index].id);
                  },
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
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
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {
          //     _showPostLoan();
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.favorite),
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => FovoritesPage(_favorites)));
          //   },
          // ),
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
    // _getModel();
  }

  _getModel() {
    setState(() {
      progressDialog.show();
    });
    ModelAPI.getModels(url).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        this.models.clear();
        List<Model> tempList = new List();
        tempList = list.map((model) => Model.fromJson(model)).toList();
        tempList.sort((a, b) {
          if (a.rating > b.rating) return 1;
          return -1;
        });
        if (tempList.length < 10) {
          for (int i = 0; i < tempList.length; i++) {
            models.add(tempList[i]);
          }
        } else {
          for (int i = 0; i < 10; i++) {
            models.add(tempList[i]);
          }
        }
      });
    }).then((data) {
      _logs.add(" GET MADE ON  " + this.url);
      print(_logs);
      setState(() {
        progressDialog.hide();
      });
    });
  }

  _makePostReq(id) async {
    setState(() {
      progressDialog.show();
    });
    String jsonDict = '{"id":' + id.toString() + '}';
    Map<String, String> headers = {"Content-type": "application/json"};
    print(jsonDict);
    Response response = await post('http://192.168.1.104:2201/increment',
        headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode != 200) {
      final Map parsed = json.decode(response.body.toString());
      _logs.add(' BAD CODE ' + statusCode.toString() + '  ' + parsed['text']);
      print(_logs.toString());
      Toast.show(parsed['text'], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      _logs.add(' 200 POST ');
      print(_logs.toString());
      setState(() {
        for (int i = 0; i < models.length; i++) {
          if (models[i].id == id) {
            models[i].rating = models[i].rating + 1;
          }
        }
      });
    }
    setState(() {
      progressDialog.hide();
    });
  }
}
