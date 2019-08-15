import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/twitter.dart';
import '../models/note.dart';
import '../models/config.dart';
import '../widgets/sketcher.dart';

class TweetForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TweetFormState();
}

class _TweetFormState extends State<TweetForm> {
  File file;
  String text = '';

  @override
  Widget build(BuildContext context) {
    TwitterModel _twitter = Provider.of<TwitterModel>(context);
    ConfigModel _config = Provider.of<ConfigModel>(context);
    NoteModel _note = Provider.of<NoteModel>(context);

    if (file == null) {
      Painter(_note, _config).writeGif().then((gif) {
        setState(() {
          file = gif;
        });
      });
      return Container(
        height: 200,
        child: Column(
          children: [
            Text('エンコード中…'),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 140,
            decoration: InputDecoration(
              hintText: '本文',
            ),
            onChanged: (String value) => text = value,
          ),
          RaisedButton(
            child: Text(
              'ツイート',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlueAccent,
            onPressed: () {
              _twitter.login().then((_) {
                _twitter.tweet(text, file).then((result) {
                  if (result.isSuccess) {
                    Navigator.pop(context, 'ツイートしました');
                  } else {
                    Navigator.pop(context, 'ツイートに失敗しました');
                  }
                });
              }).catchError((e) {
                Navigator.pop(context, e.message);
              });
            },
          ),
          Image.file(file, height: 200)
        ],
      ),
    );
  }
}
