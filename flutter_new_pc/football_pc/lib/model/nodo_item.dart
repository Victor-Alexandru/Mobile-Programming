import 'package:flutter/material.dart';

class ChampionshipItem extends StatelessWidget {
  String _trophy;
  String _totalMatches;
  int _id;

  ChampionshipItem(this._trophy, this._totalMatches);

  ChampionshipItem.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _totalMatches = json['total_matches'].toString(),
        _trophy = json['trophy'].toString();

  ChampionshipItem.map(dynamic obj) {
    this._trophy = obj["trophy"];
    this._totalMatches = obj["totalMatches"];
    this._id = obj["id"];
  }

  String get totalMatches => _totalMatches;

  String get trophy => _trophy;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  set trophy(String value) {
    _trophy = value;
  }

  set totalMatches(String value) {
    _totalMatches = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["trophy"] = _trophy;
    map["totalMatches"] = _totalMatches;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  ChampionshipItem.fromMap(Map<String, dynamic> map) {
    this._totalMatches = map["totalMatches"];
    this._trophy = map["trophy"];
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
            "T: $_trophy ",
            style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Text(
              "Has the total matches: $_totalMatches",
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
