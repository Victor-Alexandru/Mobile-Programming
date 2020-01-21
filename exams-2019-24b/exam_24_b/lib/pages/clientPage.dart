import 'dart:convert';

import 'package:exam_24_b/API/GenreApi.dart';
import 'package:exam_24_b/model/song.dart';
import 'package:exam_24_b/pages/genreSongPage.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatelessWidget {
  // This widget is the root of your application.
  List<Song> favorites;

  ClientPage(List<Song> favorites) {
    this.favorites = favorites;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ClientPageApp('Client Page', favorites),
    );
  }
}

class ClientPageApp extends StatefulWidget {
  ClientPageApp(String title, List<Song> favorites) {
    this.title = title;
    this.favorites = favorites;
  }

  List<Song> favorites;
  String title;

  @override
  _ClientPageAppState createState() => _ClientPageAppState(favorites);
}

class _ClientPageAppState extends State<ClientPageApp> {
  List<String> genres = new List<String>();
  List<Song> favorites;

  _ClientPageAppState(List<Song> favorites) {
    this.favorites = favorites;
  }
  final String url = "http://192.168.1.104:2224/genres";

  Widget GenreCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GenreSongPage(genres[index], this.favorites)));
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
                      genres[index],
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
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _getGenres();
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) => GenreCell(context, index),
          ),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    _getGenres();
  }

  _getGenres() {
    GenreAPI.getGenres(url).then((response) {
      setState(() {
        print(response.body);
        Iterable list = json.decode(response.body);
        this.genres.clear();
        list.forEach((e) {
          this.genres.add(e);
        });
      });
    });
  }
}
