import 'package:flutter/material.dart';
import './config.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  @override
  void initState() {
    config.init().then((Config config) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text('ペンの太さ'),
            Slider(
              label: config.strokeWidth.toString(),
              min: 1,
              max: 10,
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              divisions: 9,
              value: config.strokeWidth,
              onChanged: (double value) {
                setState(() {
                  config.strokeWidth = value;
                  config.save();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
