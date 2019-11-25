import 'package:flutter/material.dart';

class TeamItem extends StatelessWidget {
  String _teamName;
  String _points;
  int _championshipId;
  int _id;

  TeamItem(this._teamName, this._points,this._championshipId);

  TeamItem.map(dynamic obj) {
    this._teamName = obj["teamName"];
    this._points = obj["points"];
    this._championshipId = obj["championshipId"];
    this._id = obj["id"];
  }

  int get championshipId => _championshipId;

  String get points => _points;

  String get teamName => _teamName;

  int get id => _id;

  set championshipId(int val) {
    _championshipId = val;
  }

  set id(int value) {
    _id = value;
  }

  set teamName(String value) {
    _teamName = value;
  }

  set points(String value) {
    _points = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["teamName"] = _teamName;
    map["points"] = _points;
    map["championshipId"] = _championshipId;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  TeamItem.fromMap(Map<String, dynamic> map) {
    this._points = map["points"];
    this._teamName = map["teamName"];
    this._championshipId = map["championshipId"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "T: $_teamName ",
            style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Text(
              "  points : $_points",
              style: new TextStyle(
                color: Colors.white70,
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
