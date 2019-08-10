import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/sketcher.dart';

class EditScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NoteModel _note = Provider.of<NoteModel>(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Sketcher(),
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
                      _note.currentPage.lines.clear();
                    },
                  ),
                  FloatingActionButton(
                    heroTag: 'left',
                    backgroundColor: Colors.red,
                    child: Icon(Icons.arrow_left),
                    onPressed: () => _note.backPage(),
                  ),
                  FloatingActionButton(
                    heroTag: 'play',
                    backgroundColor: Colors.red,
                    child:
                        Icon(_note.isPlaying ? Icons.stop : Icons.play_arrow),
                    onPressed: () => _note.play(),
                  ),
                  FloatingActionButton(
                    heroTag: 'right',
                    backgroundColor: Colors.red,
                    child: Icon(Icons.arrow_right),
                    onPressed: () => _note.pushPageAndCreate(),
                  ),
                  FloatingActionButton(
                    heroTag: 'menu',
                    backgroundColor: Colors.red,
                    child: Icon(Icons.menu),
                    onPressed: () => Navigator.pushNamed(context, '/menu'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}