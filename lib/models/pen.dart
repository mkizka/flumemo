import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PenModel extends ChangeNotifier {
  Color _color = Colors.primaries[0];
  double _width = 3;

  Color get color => _color;

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
