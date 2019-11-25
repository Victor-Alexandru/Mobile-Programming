//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//
//class Championship extends StatelessWidget {
//  int _id;
//  String _totalMatches;
//  String _trophy;
//  bool _isFunctional;
//
//  Championship(this._trophy, this._totalMatches, this._isFunctional);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      margin: const EdgeInsets.all(10.0),
//      child: new Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//            _trophy,
//            style: new TextStyle(
//                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 17),
//          ),
//          new Container(
//            margin: const EdgeInsets.only(top: 5.0),
//            child: new Text(
//                  () {
//                return _totalMatches;
//              }(),
//              style: new TextStyle(color: Colors.pink, fontSize: 13),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  Computer.map(dynamic obj) {
//    this._totalMatches = obj["model"];
//    if (obj["isFunctional"] == 1) {
//      this._isFunctional = true;
//    } else {
//      this._isFunctional = false;
//    }
//    this._trophy = obj["brand"];
//    this._id = obj["id"];
//  }
//
//  Map<String, dynamic> toMap() {
//    var map = new Map<String, dynamic>();
//    map["brand"] = _trophy;
//    map["model"] = _totalMatches;
//    if (this._isFunctional == true) {
//      map["isFunctional"] = 1;
//    } else {
//      map["isFunctional"] = 0;
//    }
//
//    if (_id != null) {
//      map["id"] = _id;
//    }
//    return map;
//  }
//
//  Computer.fromMap(Map<String, dynamic> map) {
//    this._id = map["id"];
//    this._totalMatches = map["model"];
//    this._trophy = map["brand"];
//    if (map["isFunctional"] == 1) {
//      this._isFunctional = true;
//    } else {
//      this._isFunctional = false;
//    }
//  }
//
//  int get id => _id;
//
//  set id(int value) {
//    _id = value;
//  }
//
//  String get totalMatches => _totalMatches;
//
//  set totalMatches(String value) {
//    _totalMatches = value;
//  }
//
//  String get trophy => _trophy;
//
//  set trophy(String value) {
//    _trophy = value;
//  }
//}