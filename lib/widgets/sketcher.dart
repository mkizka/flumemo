import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../models/pen.dart';
import '../models/config.dart';

class Sketcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);
    final PenModel _pen = Provider.of(context);
    final ConfigModel _config = Provider.of<ConfigModel>(context);

    Paint paint = _pen.paint;
    if (!_pen.isActive) paint.color = _note.backgroundColor;

    bool isInSketcher(Offset offset) {
      return 0 <= offset.dy && offset.dy <= context.size.height;
    }

    void _onDragStart(DragDownDetails details) {
      if (!isInSketcher(details.localPosition)) return;
      _note.currentPage.addLine(paint, details.localPosition);
      _note.notifyListeners();
    }

    void _onDragUpdate(DragUpdateDetails details) {
      if (!isInSketcher(details.localPosition)) return;
      _note.currentPage.updateLine(details.localPosition);
      _note.notifyListeners();
    }

    return Container(
      color: _note.backgroundColor,
      child: GestureDetector(
        onPanDown: _onDragStart,
        onPanUpdate: _onDragUpdate,
        child: CustomPaint(
          painter: Painter(_note, onionRange: _config.onionRange),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
          ),
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  final NoteModel note;
  final int onionRange;
  int pageIndex;
  double sizeRate;

  Painter(
    this.note, {
    this.pageIndex,
    this.onionRange = 0,
    this.sizeRate = 1.0,
  }) {
    if (this.pageIndex == null) this.pageIndex = this.note.pageIndex;
  }

  Size get size => note.context.size;

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }

  void _paintOnion(Canvas canvas) {
    if (!note.isPlaying) {
      List<int> onionIndexList = List.generate(onionRange, (int i) => -(i + 1));

      onionIndexList.reversed.forEach((int onionIndex) {
        if (note.pageIndex + onionIndex < 0) return;

        note.getRelativePage(onionIndex).lines.forEach((Line line) {
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
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    Paint paint = Paint()..color = note.backgroundColor;
    canvas.drawPath(path, paint);
  }

  void paint(Canvas canvas, Size size) {
    _paintOnion(canvas);
    note.pages[pageIndex].lines.forEach((Line line) {
      List<Offset> scaledPoints = [];
      for (var point in line.points) {
        Offset scaledPoint = Offset(point.dx * sizeRate, point.dy * sizeRate);
        scaledPoints.add(scaledPoint);
      }

      Paint scaledPaint = line.getPaint()..strokeWidth *= sizeRate;

      canvas.drawPoints(PointMode.polygon, scaledPoints, scaledPaint);
    });
  }

  Future<File> save(String path, Page page) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);

    _paintBackground(canvas);
    page.lines.forEach((Line line) {
      canvas.drawPoints(PointMode.polygon, line.points, line.paint);
    });

    Picture picture = recorder.endRecording();

    ui.Image image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    ByteData data = await image.toByteData(format: ImageByteFormat.png);
    return File(path)..writeAsBytesSync(data.buffer.asUint8List());
  }

  Future<File> writeGif() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    _flutterFFmpeg.setLogLevel(LogLevel.AV_LOG_ERROR);
    final Directory tempDir = await getTemporaryDirectory();
    final String uniqueId = 'flumemo_' + Uuid().v4().substring(0, 8);

    Directory('${tempDir.path}/$uniqueId').createSync();

    for (int i = 0; i < note.pages.length; i++) {
      await save(
        '${tempDir.path}/$uniqueId/${i.toString().padLeft(3, '0')}.png',
        note.pages[i],
      );
    }

    String arguments = '' +
        '-i "${tempDir.path}/$uniqueId/%03d.png" ' +
        '-vf palettegen ' +
        '${tempDir.path}/$uniqueId/palette.png';

    await _flutterFFmpeg.execute(arguments);

    String arguments2 = '' +
        '-f image2 ' +
        '-r ${note.fps.toString()} ' +
        '-i "${tempDir.path}/$uniqueId/%03d.png" ' +
        '-i "${tempDir.path}/$uniqueId/palette.png" ' +
        '-filter_complex paletteuse ' +
        '${tempDir.path}/$uniqueId/output.gif';

    await _flutterFFmpeg.execute(arguments2);

    return File('${tempDir.path}/$uniqueId/output.gif');
  }
}
