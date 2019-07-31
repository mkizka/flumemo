import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Line currentLine = Line([], Colors.black);
  List<Line> lines = [];

  List<String> _logs = [];
  bool isDebug = true;

  List<Widget> createTextList(List<String> logs, {int lineCount: 15}) {
    if (logs.length > lineCount) {
      logs = logs.sublist(logs.length - lineCount, logs.length);
    }
    return logs.map((String log) => Text(log)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(List.from(lines)..add(currentLine)),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox box = context.findRenderObject();
                Offset point = box.globalToLocal(details.globalPosition);
                currentLine.points.add(point);
                _logs.add('onPanUpdate');
              });
            },
            onPanEnd: (DragEndDetails details) {
              if (currentLine.points.length >= 1) {
                lines.add(currentLine);
                currentLine = Line([], Colors.black);
              }
              _logs.add('onPanEnd');
            },
            child: sketchArea,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: createTextList(_logs),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'clear Screen',
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            lines.clear();
            _logs.add('clear');
          });
        },
      ),
    );
  }
}

class Line {
  List<Offset> points;
  Color color;

  Line(this.points, this.color);
}

class Sketcher extends CustomPainter {
  final List<Line> lines;

  Sketcher(this.lines);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.lines != lines;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    lines.forEach((Line line) {
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    });
  }
}
