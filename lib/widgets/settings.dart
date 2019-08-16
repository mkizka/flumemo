import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pen.dart';
import '../models/note.dart';
import '../models/config.dart';

class SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfigModel _config = Provider.of<ConfigModel>(context);
    PenModel _pen = Provider.of<PenModel>(context);
    NoteModel _note = Provider.of<NoteModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('ペンの太さ'),
          Slider(
            label: _pen.width.toString(),
            min: 1,
            max: 10,
            divisions: 9,
            value: _pen.width,
            onChanged: (double value) => _pen.width = value,
          ),
          Text('透過枚数'),
          Slider(
            label: _config.onionRange.toString(),
            min: 0,
            max: 3,
            divisions: 3,
            value: _config.onionRange.toDouble(),
            onChanged: (double value) => _config.onionRange = value.toInt(),
          ),
          Text('fps'),
          Slider(
            label: _note.fps.toString(),
            min: 0,
            max: 30,
            divisions: 30,
            value: _note.fps.toDouble(),
            onChanged: (double value) => _note.fps = value.toInt(),
          ),
        ],
      ),
    );
  }
}
