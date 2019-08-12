import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

import '../models/note.dart';
import '../models/pen.dart';
import '../models/config.dart';

class Sketcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _note = Provider.of<NoteModel>(context);
    final _pen = Provider.of<PenModel>(context);

    void _onDragStart(DragStartDetails detals) {
      _note.currentPage.addLine(_pen, detals.localPosition);
      _note.notifyListeners();
    }

    void _onDragUpdate(DragUpdateDetails details) {
      _note.currentPage.updateLine(details.localPosition);
      _note.notifyListeners();
    }

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onVerticalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onVerticalDragUpdate: _onDragUpdate,
      child: CustomPaint(
        painter: Painter(context, _note),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  final NoteModel _note;
  final BuildContext _context;
  ConfigModel _config;

  Painter(this._context, this._note);

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }

  void _paintOnion(Canvas canvas) {
    _config = Provider.of<ConfigModel>(_context);
    if (_config.isReady && !_note.isPlaying) {
      List<int> onionIndexList = List.generate(
        _config.onionRange,
        (int i) => -(i + 1),
      );

      onionIndexList.reversed.forEach((int onionIndex) {
        if (_note.pageIndex + onionIndex < 0) return;

        _note.getRelativePage(onionIndex).lines.forEach((Line line) {
          canvas.drawPoints(
            PointMode.polygon,
            line.points,
            line.getOnionPaint(onionIndex),
          );
        });
      });
    }
  }

  void _paintBackground(Canvas canvas) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(_context.size.width, 0);
    path.lineTo(_context.size.width, _context.size.height);
    path.lineTo(0, _context.size.height);
    path.close();
    Paint paint = Paint()..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  void _paint(Canvas canvas) {
    _note.currentPage.lines.forEach((Line line) {
      canvas.drawPoints(PointMode.polygon, line.points, line.paint);
    });
  }

  void paint(Canvas canvas, Size size) {
    _paintOnion(canvas);
    _paint(canvas);
  }

  Future<Null> save() async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    _paintBackground(canvas);
    _paint(canvas);

    Picture picture = recorder.endRecording();

    ui.Image image = await picture.toImage(
      _context.size.width.toInt(),
      _context.size.height.toInt(),
    );
    ByteData data = await image.toByteData(format: ui.ImageByteFormat.png);
    await ImagePickerSaver.saveFile(fileData: data.buffer.asUint8List());
  }
}
