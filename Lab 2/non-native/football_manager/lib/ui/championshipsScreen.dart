import 'package:flutter/material.dart';
import 'package:football_manager/model/nodo_item.dart';
import 'package:football_manager/model/nodo_item.dart' as prefix0;
import 'package:football_manager/util/db.dart';
import 'package:football_manager/ui/teamScreen.dart';

class ChampionshipsScreen extends StatefulWidget {
  @override
  _ChampionshipsScreenState createState() => new _ChampionshipsScreenState();
}

class _ChampionshipsScreenState extends State<ChampionshipsScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();
  var databaseHelper = DbHelper();

  List<ChampionshipItem> _list = <ChampionshipItem>[];

  _readFromDb() async {
    List items = await databaseHelper.getItems();
    setState(() {
      items.forEach((item) {
        this._list.add(ChampionshipItem.map(item));
      });
    });
    print("------------------------------");
    print(items.toString());
    print("------------------------------");
  }

  @override
  void initState() {
    super.initState();
    _readFromDb();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _list.length,
                  itemBuilder: (_, int index) {
                    return new Card(
                      color: Colors.white10,
                      child: new ListTile(
                        title: _list[index],
                        onTap: () => this._update(_list[index], index),
                        trailing: new Listener(
                          key: new Key(_list[index].trophy),
                          child:
                              new Icon(Icons.remove_circle, color: Colors.red),
                          onPointerDown: (pointerEvent) =>
                              this._delete(_list[index].id, index),
                        ),
                      ),
                    );
                  })),
          new Divider(
            height: 1.0,
          )
        ],
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
    var removed = await databaseHelper.delete(id);
    if (removed != null) {
      setState(() {
        _list.removeAt(index);
      });
    }
  }

  _handleSubmitted(String text, String textTwo) async {
    var c = new ChampionshipItem(text, textTwo);
    ChampionshipItem saved = await this.databaseHelper.insertC(c);
    if (saved != null) {
      setState(() => this._list.add(c));
      _textEditingController.clear();
      _textEditingControllerTM.clear();
      Navigator.pop(context);
    }
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
                  Navigator.pop(context),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamScreen(championshipId: c.id)),
                  )
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
    var c1 = new ChampionshipItem(t1, t2);
    c1.id = c.id;
    var result = await databaseHelper.update(c1);
    setState(() {
      if (result != null) {
        _list[index] = c1;
      }
    });
    _textEditingController.clear();
    _textEditingControllerTM.clear();
    Navigator.pop(context);
  }
}
