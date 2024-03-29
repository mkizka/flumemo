import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import './pen.dart';

List<Color> backgroundColorList = [
  Colors.lightBlueAccent,
  Colors.lightGreenAccent,
];

class NoteModel extends ChangeNotifier {
  List<Page> pages = [Page()];
  int pageIndex = 0;
  bool isPlaying = false;
  Color _backgroundColor = backgroundColorList[0];
  int _fps = 8;
  BuildContext context;

  int get fps => _fps;

  set fps(int value) {
    _fps = value;
    notifyListeners();
  }

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color value) {
    _backgroundColor = value;
    notifyListeners();
  }

  void reset() {
    pages = [Page()];
    pageIndex = 0;
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
    if (pageIndex >= pages.length) {
      pageIndex = 0;
    }
    currentPage.endLine();
    notifyListeners();
  }

  void pushPageAndCreate() {
    pageIndex++;
    if (pageIndex >= pages.length) {
      pages.add(Page());
    }
    currentPage.endLine();
    notifyListeners();
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
    notifyListeners();
  }

  void setPage(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void deletePage(int index) {
    pages.removeAt(index);
    if (index > pages.length - 1) {
      pageIndex = pages.length - 1;
    }
    notifyListeners();
  }

  void insertPage(int index) {
    pages.insert(index, Page());
    notifyListeners();
  }

  void copyPage(int index) {
    pages.insert(index, Page.from(pages[index]));
    notifyListeners();
  }

  void exchangePage(int index, int relativeIndex) {
    Page temp = Page.from(pages[index]);
    pages[index] = Page.from(pages[index + relativeIndex]);
    pages[index + relativeIndex] = temp;
    pageIndex += relativeIndex;
    notifyListeners();
  }

  Page getRelativePage(int i) => pages[pageIndex + i];

  Page get currentPage => getRelativePage(0);

  String get pageStateDisplay {
    return (pageIndex + 1).toString() + '/' + pages.length.toString();
  }
}

class Page {
  List<Line> lines = [];
  List<Line> redoableLines = [];

  Page();

  factory Page.from(Page other) {
    return Page()
      ..lines = other.lines.map((Line l) => Line.from(l)).toList()
      ..redoableLines = other.redoableLines;
  }

  void addLine(PaintInk paint, Offset point) {
    lines.add(Line(paint)..points.add(point));
    redoableLines.clear();
  }

  void updateLine(PaintInk paint, Offset point) {
    if (lines.isEmpty || lines.last.isFinished) {
      addLine(paint, point);
    } else {
      lines.last.points.add(point);
    }
  }

  void endLine() {
    if (lines.isNotEmpty && !lines.last.isFinished) {
      lines.last.points.add(null);
    }
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
  PaintInk paint;
  List<Color> _onionColors = [
    Colors.grey,
    Colors.grey.shade400,
    Colors.grey.shade300,
  ];

  Line(this.paint);

  factory Line.from(Line other) {
    return Line(other.paint.copy())..points = other.points;
  }

  bool get isFinished => points.isNotEmpty && points.last == null;

  List<Offset> get drawablePoints {
    List<Offset> result = List.from(points);
    if (isFinished) result.removeLast();
    return result;
  }

  PaintInk getOnionPaint(int onionIndex) {
    Color color = _onionColors[-(onionIndex + 1)];
    if (paint.isTransparent) {
      color = paint.color;
    }
    return PaintInk.from(paint).copy(newColor: color);
  }
}
