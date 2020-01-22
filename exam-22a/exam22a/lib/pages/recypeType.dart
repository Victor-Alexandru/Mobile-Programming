import 'dart:convert';

import 'package:exam22a/api/modelApi.dart';
import 'package:exam22a/model/model.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RecipesType extends StatefulWidget {
  String _type;

  RecipesType(String type) {
    _type = type;
  }

  @override
  _RecipesTypeState createState() => _RecipesTypeState(_type);
}

class _RecipesTypeState extends State<RecipesType> {
  String _type;
  String _url;
  List<Model> models = new List<Model>();
  ProgressDialog progressDialog;

  _RecipesTypeState(String type) {
    _type = type;
    _url = 'http://192.168.1.104:2201/recipes/' + type;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getSongs();
  // }

  _getModel() {
    setState(() {
      progressDialog.show();
    });
    ModelAPI.getModels(_url).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        this.models.clear();
        models = list.map((model) => Model.fromJson(model)).toList();
      });
    }).then((data) {
      setState(() {
        progressDialog.hide();
      });
    });
  }

  Widget ModelCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SongDetailPage(songs[index], _favorites)));
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
                Icon(Icons.navigate_next, color: Colors.black38),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(_type), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            _getModel();
          },
        )
      ]),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) => ModelCell(context, index),
          ),
        ]),
      ),
    );
  }
}
