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
  final Function dialog;
  final Function onTap;

  PopupChoice(this.title, {this.dialog, this.onTap});

  void onSelected(BuildContext context) {
    if (onTap == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => dialog(context),
      );
    } else {
      onTap(context);
    }
  }
}

List<PopupChoice> _popupChoiceList = [
  PopupChoice(
    'ノートをリセット',
    dialog: (BuildContext context) => AlertDialog(
      content: Text('リセットすると全てのページが削除され、元には戻せません。よろしいですか？'),
      actions: [
        FlatButton(
          child: Text("キャンセル"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("リセット"),
          onPressed: () {
            final NoteModel note = Provider.of<NoteModel>(context);
            note.reset();
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
  PopupChoice('Flumemoをシェア', onTap: (BuildContext context) {
    Share.share('#flumemo https://github.com/Compeito/flumemo/releases');
  }),
];

class EditScene extends StatelessWidget {
  final GlobalKey _sketcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final NoteModel note = Provider.of<NoteModel>(context);
    final PenModel pen = Provider.of<PenModel>(context);
    BuildContext scaffoldContext;

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
              onPressed: !note.isPlaying
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
              onPressed: !note.isPlaying
                  ? () async {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("プレビュ－"),
                          content: TweetForm(),
                        ),
                      );
                      if (result != null) {
                        Scaffold.of(scaffoldContext).showSnackBar(
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
                      !note.isPlaying && note.currentPage.lines.isNotEmpty
                          ? () {
                              note.currentPage.undo();
                              note.notifyListeners();
                            }
                          : null,
                ),
                IconButton(
                  icon: Icon(Icons.redo),
                  onPressed: !note.isPlaying &&
                          note.currentPage.redoableLines.isNotEmpty
                      ? () {
                          note.currentPage.redo();
                          note.notifyListeners();
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(note.isPlaying ? Icons.stop : Icons.play_arrow),
                  onPressed: () {
                    // 再生時には何度も再描画されるので範囲をSketcher()に限定するため
                    final NoteModel sketcherNote = Provider.of<NoteModel>(
                      _sketcherKey.currentContext,
                    );
                    sketcherNote.play();
                  },
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: 70,
                  child: Center(
                    child: Text(
                      note.pageStateDisplay,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: !note.isPlaying ? () => note.backPage() : null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed:
                      !note.isPlaying ? () => note.pushPageAndCreate() : null,
                ),
              ],
            ),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return Sketcher(
            key: _sketcherKey,
          );
        }),
      ),
    );
  }
}
