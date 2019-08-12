import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/sketcher.dart';

class EditScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ButtonTheme(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              buttonColor: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.layers),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        _note.pageStateDisplay,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.cloud_upload),
                      onPressed: () => Painter(context, _note).save(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
                      child:
                          Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
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
