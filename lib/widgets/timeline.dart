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
    final NoteModel _note = Provider.of<NoteModel>(context);
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
                  color: index == _note.pageIndex
                      ? Colors.black.withOpacity(0.1)
                      : Colors.white,
                  child: ListTile(
                    leading: Text((index + 1).toString()),
                    title: CustomPaint(
                      size: scaledSize(size, 0.15),
                      painter: Painter(_note, pageIndex: index, sizeRate: 0.15),
                    ),
                    onTap: () => _note.setPage(index),
                  ),
                );
              },
              itemCount: _note.pages.length,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: Icon(Icons.keyboard_arrow_up),
                onPressed: _note.pageIndex > 0
                    ? () => _note.exchangePage(_note.pageIndex, -1)
                    : null,
              ),
              Text(_note.pageStateDisplay),
              FlatButton(
                child: Icon(Icons.keyboard_arrow_down),
                onPressed: _note.pageIndex < _note.pages.length - 1
                    ? () => _note.exchangePage(_note.pageIndex, 1)
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
                  onPressed: _note.pages.length > 1
                      ? () => _note.deletePage(_note.pageIndex)
                      : null,
                ),
                FlatButton(
                  child: Text('追加'),
                  onPressed: () => _note.insertPage(_note.pageIndex),
                ),
                FlatButton(
                  child: Text('複製'),
                  onPressed: () => _note.copyPage(_note.pageIndex),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
