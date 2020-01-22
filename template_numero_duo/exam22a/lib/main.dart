import 'package:exam22a/pages/selectionPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // List<String> _logs = new List();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectionPage(),
    );
  }
}
