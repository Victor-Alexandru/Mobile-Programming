import 'package:flutter/material.dart';
import 'package:football_manager/model/nodo_item.dart';
import 'package:football_manager/model/nodo_item.dart' as prefix0;
import 'package:football_manager/model/teamItem.dart';
import 'package:football_manager/util/db.dart';

class TeamScreen extends StatefulWidget {
  final int championshipId;

  TeamScreen({Key key, @required this.championshipId}) : super(key: key);

  @override
  _TeamScreenState createState() =>
      new _TeamScreenState(championshipId: this.championshipId);
}

class _TeamScreenState extends State<TeamScreen> {
  final int championshipId;

  _TeamScreenState({Key key, @required this.championshipId}) : super();

  final TextEditingController _textEditingController =
      new TextEditingController();
  final TextEditingController _textEditingControllerTM =
      new TextEditingController();
  var databaseHelper = DbHelper();

  List<TeamItem> _list = <TeamItem>[];

  _readFromDb() async {
    List items = await databaseHelper.getItemsTeams(championshipId);
    setState(() {
      items.forEach((item) {
        this._list.add(TeamItem.map(item));
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
                          key: new Key(_list[index].teamName),
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
              labelText: "Name",
              hintText: "not blank",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTM,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Points",
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

  void _handleSubmitted(String text, String textTwo) async {
    var c = new TeamItem(text, textTwo, championshipId);
    TeamItem saved = await this.databaseHelper.insertTeam(c);
    if (saved != null) {
      setState(() => this._list.add(c));
      _textEditingController.clear();
      _textEditingControllerTM.clear();
      Navigator.pop(context);
    }
  }

  _delete(int id, int index) async {
    var removed = await databaseHelper.deleteTeam(id);
    if (removed != null) {
      setState(() {
        _list.removeAt(index);
      });
    }
  }

  _update(TeamItem team, int index) {
    _textEditingControllerTM.text = team.points;
    _textEditingController.text = team.teamName;
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Name",
              hintText: "not blank",
            ),
          )),
          new Expanded(
              child: new TextField(
            controller: _textEditingControllerTM,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Points",
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
                _handleUpdate(team, index, _textEditingController.text,
                    _textEditingControllerTM.text);
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

  void _handleUpdate(TeamItem team, int index, String t1, String t2) async {
    var c1 = new TeamItem(t1, t2, championshipId);
    c1.id = team.id;
    var result = await databaseHelper.updateTeam(c1);
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
