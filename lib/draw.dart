import 'dart:async';
import 'package:flutter/material.dart';
import './menu.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  NoteController _controller = NoteController(
    pages: [Page(lines: [])],
    pageIndex: 0,
    fps: 4,
  );

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

    final _displayStyle = TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
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
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          child: Column(
            children: [
              Text(
                _controller.getPageStateDisplay(),
                style: _displayStyle,
              ),
              Text(
                _controller.fps.toString() + 'fps',
                style: _displayStyle,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: 'clear',
                backgroundColor: Colors.red,
                child: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _controller.currentPage.lines.clear();
                  });
                },
              ),
              FloatingActionButton(
                heroTag: 'left',
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    _controller.backPage();
                  });
                },
              ),
              FloatingActionButton(
                heroTag: 'play',
                backgroundColor: Colors.red,
                child:
                    Icon(_controller.isPlaying ? Icons.stop : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    _controller.isPlaying = !_controller.isPlaying;
                  });
                  if (_controller.isPlaying) {
                    Timer.periodic(
                      Duration(milliseconds: 1000 ~/ _controller.fps),
                      (Timer timer) {
                        if (!_controller.isPlaying) {
                          timer.cancel();
                        }
                        setState(() {
                          _controller.pushPageAndLoop();
                        });
                      },
                    );
                  }
                },
              ),
              FloatingActionButton(
                heroTag: 'right',
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    _controller.pushPageAndCreate();
                  });
                },
              ),
              FloatingActionButton(
                heroTag: 'menu',
                backgroundColor: Colors.red,
                child: Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Menu()),
                  );
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
  int fps;
  bool isPlaying = false;

  NoteController({this.pages, this.pageIndex, this.fps});

  void _pushPage() {
    currentPage.mergeLines();
    pageIndex++;
  }

  void pushPageAndLoop() {
    _pushPage();
    if (pageIndex >= pages.length) {
      pageIndex = 0;
    }
  }

  void pushPageAndCreate() {
    _pushPage();
    if (pageIndex >= pages.length) {
      pages.add(Page(lines: []));
    }
  }

  void backPage() {
    if (pageIndex > 0) pageIndex--;
  }

  Page get currentPage {
    return pages[pageIndex];
  }

  Page get prevPage {
    return pages[pageIndex - 1];
  }

  String getPageStateDisplay() {
    return (pageIndex + 1).toString() + '/' + pages.length.toString();
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

  void _drawLines(Canvas canvas, Paint paint, List<Line> lines) {
    lines.forEach((Line line) {
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    });
  }

  void paint(Canvas canvas, Size size) {
    if (_controller.pageIndex >= 1) {
      Paint onionPaint = Paint()
        ..color = Colors.grey
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0;

      _drawLines(canvas, onionPaint, _controller.prevPage.getAllLines());
    }

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    _drawLines(canvas, paint, _controller.currentPage.getAllLines());
  }
}
