import 'dart:convert';

import 'package:exam_24_b/API/GenreApi.dart';
import 'package:exam_24_b/model/song.dart';
import 'package:exam_24_b/pages/detail/SongDetail.dart';
import 'package:flutter/material.dart';

class GenreSongPage extends StatefulWidget {
  String _genre;
  List<Song> _favorites;

  GenreSongPage(String genre, List<Song> favorites) {
    _genre = genre;
    this._favorites = favorites;
  }

  @override
  _GenreSongPageState createState() => _GenreSongPageState(_genre, _favorites);
}

class _GenreSongPageState extends State<GenreSongPage> {
  String _genre;
  String _url;
  List<Song> songs = new List<Song>();
  List<Song> _favorites;

  _GenreSongPageState(String genre, List<Song> favorites) {
    _favorites = favorites;
    _genre = genre;
    _url = 'http://192.168.1.104:2224/songs/' + genre;
  }

  @override
  void initState() {
    super.initState();
    _getSongs();
  }

  _getSongs() {
    GenreAPI.getSongs(_url).then((response) {
      setState(() {
        print(response.body);
        Iterable list = json.decode(response.body);
        songs = list.map((model) => Song.fromJson(model)).toList();
        songs.sort((a, b) {
          if (a.album.compareTo(b.album) == 0) {
            if (a.title.compareTo(b.title) < 0) return -1;
            return 1;
          }
          if (a.album.compareTo(b.album) < 0) {
            return -1;
          }
          return 1;
        });
      });
    });
  }

  Widget SongCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SongDetailPage(songs[index], _favorites)));
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
                      songs[index].title,
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(_genre), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            _getSongs();
          },
        )
      ]),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) => SongCell(context, index),
          ),
        ]),
      ),
    );
  }
}
