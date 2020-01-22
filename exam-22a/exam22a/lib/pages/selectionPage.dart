import 'package:exam22a/pages/clerkPage.dart';
import 'package:exam22a/pages/clientPage.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';

class SelectionPage extends StatelessWidget {
  // This widget is the root of your application.

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClientPage()));
              },
              child: Text(
                "User",
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
                "Owner",
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
