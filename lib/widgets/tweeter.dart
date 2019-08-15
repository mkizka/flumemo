import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/twitter.dart';

class TweetForm extends StatefulWidget {
  final File file;

  TweetForm({Key key, this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TweetFormState();
}

class _TweetFormState extends State<TweetForm> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    TwitterModel _twitter = Provider.of<TwitterModel>(context);

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
                _twitter.tweet(text, widget.file).then((result) {
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
          Image.file(
            widget.file,
            height: 200,
          )
        ],
      ),
    );
  }
}
