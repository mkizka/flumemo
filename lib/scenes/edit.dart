import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../models/config.dart';
import '../widgets/sketcher.dart';

class EditScene extends StatelessWidget {
  final GlobalKey _sketcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);
    _note.context = _sketcherKey.currentContext;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              key: _sketcherKey,
              child: Sketcher(),
            ),
            ButtonTheme(
              height: 60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              buttonColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.undo),
                      onPressed: () => _note.currentPage.lines.removeLast(),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.arrow_left),
                      onPressed: () => _note.backPage(),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Column(
                        children: [
                          Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
                          Text(_note.pageStateDisplay),
                        ],
                      ),
                      onPressed: () => _note.play(),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.arrow_right),
                      onPressed: () => _note.pushPageAndCreate(),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.menu),
                      onPressed: () => Navigator.pushNamed(context, '/menu'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
