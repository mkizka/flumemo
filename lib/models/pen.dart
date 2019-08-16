import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<Color> penColorList = [
  Colors.indigo,
  Colors.green,
];

class PenModel extends ChangeNotifier {
  Color _color = penColorList[0];
  double _width = 3;
  bool _isActive = true;

  Color get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  double get width => _width;

  set width(double width) {
    _width = width;
    notifyListeners();
  }

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    notifyListeners();
  }

  Paint get paint {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;
  }
}
