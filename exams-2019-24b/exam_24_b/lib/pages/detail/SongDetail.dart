import 'package:exam_24_b/API/SongApi.dart';
import 'package:exam_24_b/model/song.dart';
import 'package:flutter/material.dart';

class SongDetailPage extends StatefulWidget {
  Song _song;

  SongDetailPage(Song song) {
    _song = song;
  }

  @override
  _SongDetailPageState createState() => _SongDetailPageState(_song);
}

class _SongDetailPageState extends State<SongDetailPage> {
  Song _song;

  _SongDetailPageState(Song song) {
    _song = song;
  }
  _addFav() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(_song.title), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _addFav();
          },
        )
      ]),
      body: Center(
        child: Stack(children: <Widget>[
          Card(
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
                          _song.title,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          _song.genre,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          _song.album,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          _song.year.toString(),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(Icons.navigate_next, color: Colors.black38),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
