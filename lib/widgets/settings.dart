import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pen.dart';
import '../models/note.dart';
import '../models/config.dart';

class SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfigModel config = Provider.of<ConfigModel>(context);
    NoteModel note = Provider.of<NoteModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('透過枚数'),
          Slider(
            label: config.onionRange.toString(),
            min: 0,
            max: 3,
            divisions: 3,
            value: config.onionRange.toDouble(),
            onChanged: (double value) => config.onionRange = value.toInt(),
          ),
          Text('fps'),
          Slider(
            label: note.fps.toString(),
            min: 0,
            max: 30,
            divisions: 30,
            value: note.fps.toDouble(),
            onChanged: (double value) => note.fps = value.toInt(),
          ),
        ],
      ),
    );
  }
}

class PenForm extends StatelessWidget {
  static textColor(Color color) {
    return 1.05 / (color.computeLuminance() + 0.05) > 4.5
        ? Colors.white
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final PenModel _pen = Provider.of<PenModel>(context);
    final NoteModel _note = Provider.of<NoteModel>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: _pen.isActive ? Colors.grey.shade400 : null,
                  child: FlatButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('1 メイン'),
                    textColor: textColor(_pen.color),
                    color: _pen.color,
                    onPressed: () => _pen.isActive = true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: !_pen.isActive ? Colors.grey.shade400 : null,
                  child: FlatButton.icon(
                    label: Text('2 背景'),
                    icon: Icon(Icons.mode_edit),
                    textColor: textColor(_note.backgroundColor),
                    color: _note.backgroundColor,
                    onPressed: () => _pen.isActive = false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('ペンの太さ'),
            Slider(
              label: _pen.width.toString(),
              min: 1,
              max: 10,
              divisions: 9,
              value: _pen.width,
              onChanged: (double value) => _pen.width = value,
            ),
          ],
        ),
      ),
    );
  }
}
