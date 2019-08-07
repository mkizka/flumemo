import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SharedPreferences _prefs;
  bool isSwitched = false;

  _MenuState() {
    _getPrefs().then((SharedPreferences prefs) {
      setState(() {
        isSwitched = prefs.getBool('isSwitched');
      });
      _prefs = prefs;
    });
  }

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  void _save() async {
    _prefs.setBool('isSwitched', isSwitched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                _save();
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
