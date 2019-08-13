import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import './pen.dart';

class NoteModel extends ChangeNotifier {
  List<Page> page = [Page()];
  int pageIndex = 0;
  bool isPlaying = false;
  int _fps = 4;
  BuildContext context;

  int get fps => _fps;

  set fps(int value) {
    _fps = value;
    notifyListeners();
  }

  void play() {
    isPlaying = !isPlaying;
    notifyListeners();
    if (isPlaying) {
      Timer.periodic(
        Duration(milliseconds: 1000 ~/ fps),
        (Timer timer) {
          if (!isPlaying) {
            timer.cancel();
          }
          pushPageAndLoop();
          notifyListeners();
        },
      );
    }
  }

  void pushPageAndLoop() {
    pageIndex++;
    if (pageIndex >= page.length) {
      pageIndex = 0;
    }
    notifyListeners();
  }

  void pushPageAndCreate() {
    pageIndex++;
    if (pageIndex >= page.length) {
      page.add(Page());
    }
    notifyListeners();
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
    notifyListeners();
  }

  Page getRelativePage(int i) => page[pageIndex + i];

  Page get currentPage => getRelativePage(0);

  String get pageStateDisplay {
    return (pageIndex + 1).toString() + '/' + page.length.toString();
  }
}

class Page {
  List<Line> lines = [];
  List<Line> redoableLines = [];

  void addLine(PenModel pen, Offset point) {
    lines.add(Line(pen.paint)..points.add(point));
    redoableLines.clear();
  }

  void updateLine(Offset point) {
    lines.last.points.add(point);
  }

  void undo() {
    if (lines.isNotEmpty) {
      Line removedLast = lines.last;
      lines.removeLast();
      redoableLines.add(removedLast);
    }
  }

  void redo() {
    if (redoableLines.isNotEmpty) {
      lines.add(redoableLines.last);
      redoableLines.removeLast();
    }
  }
}

class Line {
  List<Offset> points = [];
  Paint paint;
  List<Color> _onionColors = [
    Colors.grey,
    Colors.grey.shade400,
    Colors.grey.shade300,
  ];

  Line(this.paint);

  getOnionPaint(int onionIndex) {
    int index = -(onionIndex + 1);
    return Paint()
      ..strokeWidth = paint.strokeWidth
      ..strokeCap = paint.strokeCap
      ..color = _onionColors[index];
  }
}
