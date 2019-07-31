import 'package:flutter/material.dart';

class Note {
  List<Page> pages;
  int pageNumber;

  void pushPage() {
    pageNumber++;
  }

  void backPage() {
    pageNumber--;
  }
}

class Page {
  List<Line> lines;

  Page(this.lines);
}

class Line {
  List<Offset> points;
  Color color;

  Line(this.points, this.color);
}

class Sketcher extends CustomPainter {
  final List<Line> lines;

  Sketcher(this.lines);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.lines != lines;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    lines.forEach((Line line) {
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    });
  }
}
