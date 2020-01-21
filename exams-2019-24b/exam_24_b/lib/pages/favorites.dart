import 'package:exam_24_b/model/song.dart';
import 'package:flutter/material.dart';

class FovoritesPage extends StatefulWidget {
  List<Song> _favorites;

  FovoritesPage(List<Song> favorites) {
    _favorites = favorites;
  }

  @override
  _FovoritesPageState createState() => _FovoritesPageState(_favorites);
}

class _FovoritesPageState extends State<FovoritesPage> {
  List<Song> _favorites;

  _FovoritesPageState(List<Song> favorites) {
    _favorites = favorites;
  }

  Widget SongCell(BuildContext ctx, int index) {
    return GestureDetector(
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
                      _favorites[index].title,
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
                      _favorites[index].album,
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
                      _favorites[index].genre,
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
                      _favorites[index].year.toString(),
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
    var favorite = Icons.favorite;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) => SongCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
