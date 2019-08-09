import 'package:flutter/widgets.dart';
import './pen.dart';

class NoteModel extends ChangeNotifier {
  List<Page> _pages = [Page()];
  int pageIndex = 0;

  void pushPageAndLoop() {
    pageIndex++;
    if (pageIndex >= _pages.length) {
      pageIndex = 0;
    }
    notifyListeners();
  }

  void pushPageAndCreate() {
    pageIndex++;
    if (pageIndex >= _pages.length) {
      _pages.add(Page());
    }
    notifyListeners();
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
    notifyListeners();
  }

  Page get currentPage {
    return _pages[pageIndex];
  }

  void addLine(PenModel pen, Offset point) {
    currentPage.addLine(pen, point);
    notifyListeners();
  }

  void updateLine(Offset point) {
    currentPage.updateLine(point);
    notifyListeners();
  }
}

class Page {
  List<Line> lines = [];

  void addLine(PenModel pen, Offset point) {
    lines.add(Line(pen)..points.add(point));
  }

  void updateLine(Offset point) {
    lines.last.points.add(point);
  }
}

class Line {
  List<Offset> points = [];
  PenModel pen;

  Line(this.pen);
}
