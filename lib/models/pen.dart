import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<Color> penColorList = [
  Colors.indigo,
  Colors.green,
];

class PenModel extends ChangeNotifier {
  Color _color = penColorList[0];
  double _width = 2;
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

  PaintInk get paint {
    return PaintInk(isTransparent: !isActive).copy(
      newColor: color,
      newCap: StrokeCap.round,
      newWidth: width,
    );
  }
}

class PaintInk extends Paint {
  final bool isTransparent;

  PaintInk({this.isTransparent = false});

  factory PaintInk.from(PaintInk other) {
    return PaintInk(isTransparent: other.isTransparent).copy(
      newColor: other.color,
      newCap: other.strokeCap,
      newWidth: other.strokeWidth,
    );
  }

  Paint copy({Color newColor, StrokeCap newCap, double newWidth}) {
    return PaintInk()
      ..color = newColor ?? color
      ..strokeCap = newCap ?? strokeCap
      ..strokeWidth = newWidth ?? strokeWidth;
  }
}
