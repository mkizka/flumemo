import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../models/pen.dart';

class Sketcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _note = Provider.of<NoteModel>(context);
    final _pen = Provider.of<PenModel>(context);

    return Listener(
      onPointerDown: (details) {
        _note.addLine(_pen, details.position);
      },
      onPointerMove: (details) {
        _note.updateLine(details.position);
      },
      onPointerUp: (details) {
        _note.updateLine(details.position);
      },
      child: CustomPaint(
        painter: _Painter(_note),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final NoteModel _note;

  _Painter(this._note);

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }

  void paint(Canvas canvas, Size size) {
    _note.currentPage.lines.forEach((Line line) {
      canvas.drawPoints(PointMode.polygon, line.points, line.pen.paint);
    });
  }
}
