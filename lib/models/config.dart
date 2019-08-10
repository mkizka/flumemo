import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigModel extends ChangeNotifier {
  SharedPreferences prefs;

  get onionRange => prefs.getDouble('onionRange') ?? 1.0;

  set onionRange(double value) {
    prefs.setDouble('onionRange', value).then((_) => notifyListeners());
  }

  ConfigModel() {
    SharedPreferences.getInstance().then((instance) => prefs = instance);
  }
}
