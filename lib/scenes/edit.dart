import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/sketcher.dart';
import '../widgets/tweeter.dart';
import '../widgets/settings.dart';
import '../widgets/timeline.dart';

class EditScene extends StatelessWidget {
  final GlobalKey _sketcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);
    _note.context = _sketcherKey.currentContext;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.layers),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('タイムライン'),
                    content: Timeline(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.palette),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('ペン'),
                    content: PenForm(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("設定"),
                    content: SettingsForm(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () async {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("プレビュ－"),
                    content: TweetForm(),
                  ),
                );
                if (result != null) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(result.toString()),
                    ),
                  );
                }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    _note.pageStateDisplay,
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
                    onPressed: () => _note.play(),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _note.backPage(),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _note.pushPageAndCreate(),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
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
