import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfigModel extends ChangeNotifier {
  int _onionRange = 0;

  int get onionRange => _onionRange;

  set onionRange(int value) {
    _onionRange = value;
    notifyListeners();
  }
}
