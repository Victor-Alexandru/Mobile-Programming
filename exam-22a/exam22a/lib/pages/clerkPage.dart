import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:exam22a/api/modelApi.dart';
import 'package:exam22a/model/model.dart';
import 'package:exam22a/pages/recypeType.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ClerkPage extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ClerkPageApp(title: 'Championships'),
    );
  }
}

class ClerkPageApp extends StatefulWidget {
  ClerkPageApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ClerkPageAppState createState() => _ClerkPageAppState();
}

class _ClerkPageAppState extends State<ClerkPageApp> {
  List<Model> models = new List<Model>();
  ProgressDialog progressDialog;
  List<String> types = new List<String>();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://192.168.1.104:2201/');

  final String url = "http://192.168.1.104:2201/types";

  final TextEditingController _textEditingControllerDelete =
      new TextEditingController();

  final TextEditingController _textEditingControllerTitle =
      new TextEditingController();

  final TextEditingController _textEditingControllerDescription =
      new TextEditingController();

  final TextEditingController _textEditingControllerAlbum =
      new TextEditingController();

  final TextEditingController _textEditingControllerGenre =
      new TextEditingController();

  final TextEditingController _textEditingControllerYear =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getModels();
  }

  Widget ModelCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecipesType(types[index])));
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
                      types[index],
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
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _getModels();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog();
            },
          )
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) => ModelCell(context, index),
          ),
          StreamBuilder(
            stream: this.channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // GoodSjson.decode(response.body.toString()
                return Text(snapshot.data.toString());
              }
              return Text('');
            },
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    _textEditingControllerTitle.clear();
    _textEditingControllerDescription.clear();
    _textEditingControllerAlbum.clear();
    _textEditingControllerGenre.clear();
    _textEditingControllerYear.clear();
    var alert = new AlertDialog(
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTitle,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "name",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerDescription,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "type",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerAlbum,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "details",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerGenre,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "time",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerYear,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "rating",
            ),
          )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              var c = new Model(
                  _textEditingControllerTitle.text,
                  _textEditingControllerDescription.text,
                  _textEditingControllerAlbum.text,
                  int.parse(_textEditingControllerGenre.text),
                  int.parse(_textEditingControllerYear.text));

              String jsonDict = '{"name":"' +
                  _textEditingControllerTitle.text +
                  '" , "type": "' +
                  _textEditingControllerDescription.text +
                  '" , "details": "' +
                  _textEditingControllerAlbum.text +
                  '" , "time": ' +
                  _textEditingControllerGenre.text +
                  ' , "rating": ' +
                  _textEditingControllerYear.text +
                  '}';

              _makePostRequest(jsonDict, c);
            },
            child: Text("Save")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _showDeleteDialog() {
    _textEditingControllerDelete.clear();
    var alert = new AlertDialog(
      content: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(
                child: new TextField(
              controller: _textEditingControllerDelete,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Id",
              ),
            )),
          ]),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _deleteReq(_textEditingControllerDelete.text);
            },
            child: Text("Delete"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _deleteReq(id) async {
    setState(() {
      progressDialog.show();
    });
    String url = 'http://192.168.1.104:2201/recipe' + '/' + id.toString();
    Response response = await ModelAPI.makeDeleteRequest(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      final Map parsed = json.decode(response.body.toString());
      print('Bad code ' + response.statusCode.toString() + parsed['text']);
    }
    setState(() {
      progressDialog.hide();
    });
  }

  _makePostRequest(jsonDict, c) async {
    setState(() {
      progressDialog.show();
    });
    print(jsonDict);
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post('http://192.168.1.104:2201/recipe',
        headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    final Map parsed = json.decode(response.body.toString());
    c.id = parsed['id'];

    print(statusCode);
    print(response.toString());

    if (statusCode == 200) {
      _textEditingControllerTitle.clear();
      _textEditingControllerDescription.clear();
      _textEditingControllerAlbum.clear();
      _textEditingControllerGenre.clear();
      _textEditingControllerYear.clear();
    }

    setState(() {
      progressDialog.hide();
    });
  }

  _getModels() async {
    this.check().then((internet) async {
      if (internet != null && internet) {
        setState(() {
          progressDialog.show();
        });
        ModelAPI.getModels(url).then((response) {
          setState(() {
            print(response.body);
            Iterable list = json.decode(response.body);
            this.types.clear();
            list.forEach((e) {
              this.types.add(e);
            });
          });
        }).then((data) {
          setState(() {
            progressDialog.hide();
          });
        });
      } else {
        Toast.show("Types works only with network", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
