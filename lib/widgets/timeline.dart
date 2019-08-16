import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import './sketcher.dart';

class Timeline extends StatelessWidget {
  static Size scaledSize(Size size, double rate) {
    return Size(size.width * rate, size.height * rate);
  }

  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: scaledSize(size, 0.8).height,
      width: scaledSize(size, 0.8).width,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CustomPaint(
            size: scaledSize(size, 0.3),
            painter: Painter(_note, pageIndex: index, sizeRate: 0.3),
          );
        },
        itemCount: _note.pages.length,
      ),
    );
  }
}
