import 'dart:convert';
import 'package:exam_24_b/pages/clerk.dart';
import 'package:exam_24_b/pages/clientPage.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  // This widget is the root of your application.
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClientPage()));
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
          ],
        ),
      ),
    ));
  }
}
