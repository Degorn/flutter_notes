import 'package:flutter/material.dart';
import 'package:notes/views/note_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      home: NoteList(),
    );
  }
}
