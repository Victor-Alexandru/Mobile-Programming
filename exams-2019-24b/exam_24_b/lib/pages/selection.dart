import 'dart:convert';
import 'package:exam_24_b/model/song.dart';
import 'package:exam_24_b/pages/clerk.dart';
import 'package:exam_24_b/pages/clientPage.dart';
import 'package:exam_24_b/pages/favorites.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  // This widget is the root of your application.
  List<Song> favorites = new List<Song>();


  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientPage(favorites)));
              },
              child: Text(
                "Client",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.green,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClerkPage()));
              },
              child: Text(
                "Clerk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FovoritesPage(favorites)));
              },
              child: Text(
                "Favorites List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
    ));
  }
}
