import 'package:flutter/material.dart';
import 'package:notepad/pages/NotesList.dart';
import 'package:notepad/utils/dbhelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var db=DataBaseHelper();
    db.fetchCategory();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Benim Not Defterim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:NotesList(),
    );
  }
}
