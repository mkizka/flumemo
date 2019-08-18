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
  File file;
  String text = '';
  bool isTweeting = false;

  @override
  Widget build(BuildContext context) {
    TwitterModel _twitter = Provider.of<TwitterModel>(context);
    NoteModel _note = Provider.of<NoteModel>(context);

    void loginAndTweet() {
      setState(() {
        isTweeting = true;
      });
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
    }

    if (file == null) {
      Painter(_note).writeGif().then((gif) {
        setState(() {
          file = gif;
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
            onChanged: (String value) => text = value,
          ),
          RaisedButton(
            child: !isTweeting
                ? Text(
                    _twitter.isAuthenticated ? 'ツイート' : 'ログインしてツイート',
                    style: TextStyle(color: Colors.white),
                  )
                : CircularProgressIndicator(),
            color: Colors.lightBlueAccent,
            onPressed: () => loginAndTweet(),
          ),
          Visibility(
            visible: _twitter.isAuthenticated,
            child: InkWell(
              child: Text(
                '@${_twitter.username}からログアウト',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => _twitter.logout(),
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
          Image.file(file, height: 200)
        ],
      ),
    );
  }
}
