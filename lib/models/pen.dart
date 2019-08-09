import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PenModel extends ChangeNotifier {
  Color _color = Colors.black;
  double _width = 3;

  get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  get width => _width;

  set width(double width) {
    _width = width;
    notifyListeners();
  }

  Paint get paint {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;
  }
}
