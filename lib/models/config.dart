import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigModel extends ChangeNotifier {
  SharedPreferences prefs;
  bool isReady = false;

  int get onionRange => prefs.getInt('onionRange') ?? 1;

  set onionRange(int value) {
    prefs.setInt('onionRange', value).then((_) => notifyListeners());
  }

  ConfigModel() {
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
      isReady = true;
      notifyListeners();
    });
  }
}
