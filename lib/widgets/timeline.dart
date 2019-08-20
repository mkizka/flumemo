import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import './sketcher.dart';

class Timeline extends StatelessWidget {
  static Size scaledSize(Size size, double rate) {
    return Size(size.width * rate, size.height * rate);
  }

  @override
  Widget build(BuildContext context) {
    final NoteModel note = Provider.of<NoteModel>(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: scaledSize(size, 0.8).height,
      width: scaledSize(size, 0.8).width,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: index == note.pageIndex
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white,
                  child: ListTile(
                    leading: Text((index + 1).toString()),
                    title: CustomPaint(
                      size: scaledSize(size, 0.15),
                      painter: Painter(note, pageIndex: index, sizeRate: 0.15),
                    ),
                    onTap: () => note.setPage(index),
                  ),
                );
              },
              itemCount: note.pages.length,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: Icon(Icons.keyboard_arrow_up),
                onPressed: note.pageIndex > 0
                    ? () => note.exchangePage(note.pageIndex, -1)
                    : null,
              ),
              Text(note.pageStateDisplay),
              FlatButton(
                child: Icon(Icons.keyboard_arrow_down),
                onPressed: note.pageIndex < note.pages.length - 1
                    ? () => note.exchangePage(note.pageIndex, 1)
                    : null,
              ),
            ],
          ),
          ButtonTheme(
            minWidth: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text('削除'),
                  onPressed: note.pages.length > 1
                      ? () => note.deletePage(note.pageIndex)
                      : null,
                ),
                FlatButton(
                  child: Text('追加'),
                  onPressed: () => note.insertPage(note.pageIndex),
                ),
                FlatButton(
                  child: Text('複製'),
                  onPressed: () => note.copyPage(note.pageIndex),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
