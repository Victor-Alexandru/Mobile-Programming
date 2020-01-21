import 'dart:convert';
import 'package:exam_24_b/model/song.dart';
import 'package:exam_24_b/pages/clerk.dart';
import 'package:exam_24_b/pages/clientPage.dart';
import 'package:exam_24_b/pages/favorites.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';

class SelectionPage extends StatelessWidget {
  // This widget is the root of your application.
  List<Song> favorites = new List<Song>();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

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
                this.check().then((internet) async {
                  if (internet != null && internet) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClerkPage()));
                  } else {
                    Toast.show("Clerk works only with network", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                });
              },
              child: Text(
                "Clerk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FovoritesPage(favorites)));
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
