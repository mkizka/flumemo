import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  NoteController _controller = NoteController();

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(_controller),
      ),
    );

    return Stack(
      children: <Widget>[
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox box = context.findRenderObject();
              Offset point = box.globalToLocal(details.globalPosition);
              _controller.currentPage.currentLine.points.add(point);
            });
          },
          onPanEnd: (DragEndDetails details) {
            _controller.currentPage.mergeLines();
          },
          child: sketchArea,
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _controller.currentPage.lines.clear();
                  });
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    _controller.backPage();
                  });
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    _controller.pushPage();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NoteController {
  List<Page> pages;
  int pageIndex;

  NoteController({this.pageIndex: 0}) {
    pages = [Page(lines: [])];
  }

  void pushPage() {
    pageIndex++;
    print(pageIndex);
    if (pageIndex >= pages.length) {
      pages.add(Page(lines: []));
      print(pages);
    }
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
    print(pageIndex);
  }

  Page get currentPage {
    return pages[pageIndex];
  }
}

class Page {
  Line currentLine = Line([], Colors.black);
  List<Line> lines = [];

  Page({this.lines});

  void mergeLines() {
    if (currentLine.points.length >= 1) {
      lines.add(currentLine);
      currentLine = Line([], Colors.black);
    }
  }

  List<Line> getAllLines() {
    if (currentLine.points.length == 0) {
      return List.from(lines);
    }
    return List.from(lines)..add(currentLine);
  }
}

class Line {
  List<Offset> points;
  Color color;

  Line(this.points, this.color);
}

class Sketcher extends CustomPainter {
  final NoteController _controller;

  Sketcher(this._controller);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    // return oldDelegate._controller.currentPage.lines != _controller.currentPage.lines;
    return true;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    List<Line> lines = _controller.currentPage.getAllLines();
    lines.forEach((Line line) {
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    });
  }
}
