import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/twitter.dart';
import '../models/note.dart';
import '../widgets/sketcher.dart';

class TweetForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TweetFormState();
}

class _TweetFormState extends State<TweetForm> {
  File _file;
  String _text = '';
  bool _isTweeting = false;

  @override
  Widget build(BuildContext context) {
    TwitterModel twitter = Provider.of<TwitterModel>(context);
    NoteModel note = Provider.of<NoteModel>(context);

    void loginAndTweet() {
      setState(() {
        _isTweeting = true;
      });
      twitter.login().then((_) {
        twitter.tweet(_text, _file).then((result) {
          if (result.isSuccess) {
            Navigator.pop(context, 'ツイートしました');
          } else {
            Navigator.pop(context, 'ツイートに失敗しました');
          }
        });
      }).catchError((e) {
        Navigator.pop(context, e.message);
      });
    }

    if (_file == null) {
      Painter(note).writeGif().then((gif) {
        setState(() {
          _file = gif;
        });
      });
      return Container(
        height: 200,
        child: Column(
          children: [
            Text('エンコード中…'),
            SizedBox(height: 40),
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
            onChanged: (String value) => _text = value,
          ),
          RaisedButton(
            child: !_isTweeting
                ? Text(
                    twitter.isAuthenticated ? 'ツイート' : 'ログインしてツイート',
                    style: TextStyle(color: Colors.white),
                  )
                : CircularProgressIndicator(),
            color: Colors.lightBlueAccent,
            onPressed: () => loginAndTweet(),
          ),
          Visibility(
            visible: twitter.isAuthenticated,
            child: InkWell(
              child: Text(
                '@${twitter.username}からログアウト',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => twitter.logout(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'ツイートにはツイッターアカウントの書き込み権限を使用します',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('プレビュー'),
          ),
          Image.file(_file, height: 200)
        ],
      ),
    );
  }
}
