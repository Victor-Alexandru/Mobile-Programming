import 'dart:convert';
import 'package:exam_28_a/API/ModelApi.dart';
import 'package:exam_28_a/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  List<String> _logs = new List<String>();

  // final _formKey = GlobalKey<FormState>();
  // String _input_total_matches;
  // String _input_trophy;
  final String url = "http://192.168.1.104:2028/all";

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
    _getModels();
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
                      models[index].size,
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
                      models[index].status,
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
            itemCount: models.length,
            itemBuilder: (context, index) => ModelCell(context, index),
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
              labelText: "size",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerGenre,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "owner",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerYear,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "status",
            ),
          )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              String jsonDict = '{"name":"' +
                  _textEditingControllerTitle.text +
                  '" , "type": "' +
                  _textEditingControllerDescription.text +
                  '" , "size": "' +
                  _textEditingControllerAlbum.text +
                  '" , "owner": "' +
                  _textEditingControllerGenre.text +
                  '" , "status": "' +
                  _textEditingControllerYear.text +
                   '"}';
              print(jsonDict);

              var c = new Model(
                  _textEditingControllerTitle.text,
                  _textEditingControllerDescription.text,
                  _textEditingControllerAlbum.text,
                  _textEditingControllerGenre.text,
                  _textEditingControllerYear.text);

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
    String url = 'http://192.168.1.104:2028/bike' + '/' + id.toString();
    Response response = await ModelAPI.makeDeleteRequest(url);
    print(_logs.toString());
    if (response.statusCode == 200) {
      _logs.add('Success delete' + response.statusCode.toString());
    } else {
      final Map parsed = json.decode(response.body.toString());
      _logs.add('Bad code ' + response.statusCode.toString() + parsed['text']);
    }
    if (response.statusCode == 200) {
      setState(() {
        models.removeWhere((a) => a.id == int.parse(id));
      });
    }
  }

  _makePostRequest(jsonDict, c) async {
    print("Inainte de request");
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post('http://192.168.1.104:2028/bike',
        headers: headers, body: jsonDict);
    int statusCode = response.statusCode;
    final Map parsed = json.decode(response.body.toString());
    c.id = parsed['id'];

    print(jsonDict);
    print(statusCode);
    print(response.toString());

    if (statusCode == 200) {
      setState(() {
        this.models.add(c);
        models.sort((a, b) {
          if (a.type.compareTo(b.type) < 0) {
            return 1;
          }
          return -1;
        });
      });

      _textEditingControllerTitle.clear();
      _textEditingControllerDescription.clear();
      _textEditingControllerAlbum.clear();
      _textEditingControllerGenre.clear();
      _textEditingControllerYear.clear();
    }
  }

  _getModels() async {
    ModelAPI.getModels(url).then((response) {
      setState(() {
        print(response.body);
        Iterable list = json.decode(response.body);
        models = list.map((model) => Model.fromJson(model)).toList();
        models.sort((a, b) {
          if (a.type.compareTo(b.type) < 0) {
            return 1;
          }
          return -1;
        });
      });
    });
  }
}
