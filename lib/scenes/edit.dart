import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
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
            ButtonTheme(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              buttonColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Icon(Icons.redo),
                      onPressed: () => _note.currentPage.redo(),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      disabledTextColor: Colors.black,
                      child: Text(_note.pageStateDisplay),
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
                      onPressed: () => _note.currentPage.undo(),
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
                      child: Icon(
                        _note.isPlaying ? Icons.stop : Icons.play_arrow,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
