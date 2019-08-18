import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../models/note.dart';
import '../models/pen.dart';
import '../widgets/sketcher.dart';
import '../widgets/tweeter.dart';
import '../widgets/settings.dart';
import '../widgets/timeline.dart';

class PopupChoice {
  final String title;
  final Widget content;
  final Function onTap;

  PopupChoice(this.title, {this.onTap, this.content});

  void onSelected(BuildContext context) {
    if (onTap == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: content,
        ),
      );
    } else {
      onTap();
    }
  }
}

List<PopupChoice> _popupChoiceList = [
  PopupChoice('Flumemoをシェア', onTap: () {
    Share.share('Flumemo https://github.com/Compeito/flumemo/releases');
  }),
];

class EditScene extends StatelessWidget {
  final GlobalKey _sketcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);
    final PenModel _pen = Provider.of<PenModel>(context);
    BuildContext _scaffoldContext;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flumemo'),
          actions: [
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
              icon: Icon(Icons.layers),
              onPressed: !_note.isPlaying
                  ? () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('タイムライン'),
                          content: Timeline(),
                        ),
                      );
                    }
                  : null,
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
              onPressed: !_note.isPlaying
                  ? () async {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("プレビュ－"),
                          content: TweetForm(),
                        ),
                      );
                      if (result != null) {
                        Scaffold.of(_scaffoldContext).showSnackBar(
                          SnackBar(
                            content: Text(result.toString()),
                          ),
                        );
                      }
                    }
                  : null,
            ),
            PopupMenuButton<PopupChoice>(
              onSelected: (PopupChoice choice) => choice.onSelected(context),
              itemBuilder: (BuildContext context) {
                return _popupChoiceList.map((item) {
                  return PopupMenuItem<PopupChoice>(
                    value: item,
                    child: Text(item.title),
                  );
                }).toList();
              },
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.undo),
                  onPressed:
                      !_note.isPlaying && _note.currentPage.lines.isNotEmpty
                          ? () {
                              _note.currentPage.undo();
                              _note.notifyListeners();
                            }
                          : null,
                ),
                IconButton(
                  icon: Icon(Icons.redo),
                  onPressed: !_note.isPlaying &&
                          _note.currentPage.redoableLines.isNotEmpty
                      ? () {
                          _note.currentPage.redo();
                          _note.notifyListeners();
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
                  onPressed: () {
                    // 再生時には何度も再描画されるので範囲をSketcher()に限定するため
                    final NoteModel note = Provider.of<NoteModel>(
                      _sketcherKey.currentContext,
                    );
                    note.play();
                  },
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      _note.pageStateDisplay,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: !_note.isPlaying ? () => _note.backPage() : null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed:
                      !_note.isPlaying ? () => _note.pushPageAndCreate() : null,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text(_pen.isActive ? '1' : '2'),
                  textColor: _pen.isActive ? _pen.color : _note.backgroundColor,
                  onPressed: () => _pen.isActive = !_pen.isActive,
                ),
              ],
            ),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return Sketcher(
            key: _sketcherKey,
          );
        }),
      ),
    );
  }
}
