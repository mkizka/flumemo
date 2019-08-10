import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/pen.dart';
import 'models/note.dart';
import 'scenes/edit.dart';
import 'scenes/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (BuildContext context) => NoteModel(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => PenModel(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => EditScene(),
          '/menu': (BuildContext context) => MenuScene()
        },
      ),
    );
  }
}
