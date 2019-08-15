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
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return ['1', '2', '3'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 60,
            child: IconTheme(
              data: IconThemeData(color: Colors.white),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.undo),
                    onPressed: _note.currentPage.lines.isNotEmpty
                        ? () {
                            _note.currentPage.undo();
                            _note.notifyListeners();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.redo),
                    onPressed: _note.currentPage.redoableLines.isNotEmpty
                        ? () {
                            _note.currentPage.redo();
                            _note.notifyListeners();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _note.backPage(),
                  ),
                  IconButton(
                    icon: Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
                    onPressed: () => _note.play(),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _note.pushPageAndCreate(),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        _note.pageStateDisplay,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              key: _sketcherKey,
              child: Sketcher(),
            ),
          ],
        ),
      ),
    );
  }
}
