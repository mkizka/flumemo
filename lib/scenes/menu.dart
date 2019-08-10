import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pen.dart';

class MenuScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PenModel _pen = Provider.of<PenModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('メニュー'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text('ペンの太さ'),
              Slider(
                label: _pen.width.toString(),
                min: 1,
                max: 10,
                activeColor: Colors.orange,
                inactiveColor: Colors.blueAccent,
                divisions: 9,
                value: _pen.width,
                onChanged: (double value) => _pen.width = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
