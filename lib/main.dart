/*
https://qiita.com/takenobi/items/c2342cd94abf9e020220
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LinePoints> lines = <LinePoints>[];
  List<Offset> nowPoints = <Offset>[];
  Color nowColor = Colors.redAccent;

  void moveGestureDetector(DragUpdateDetails detail) {
    Offset p = Offset(detail.globalPosition.dx, detail.globalPosition.dy - 60);
    setState(() {
      nowPoints.add(p);
    });
  }

  void newGestureDetector(DragStartDetails detail) {
    if (nowPoints.length != 0) {
      LinePoints l = LinePoints(new List<Offset>.from(nowPoints), nowColor);
      lines.add(l);
      nowPoints.clear();
    }
    Offset p = Offset(detail.globalPosition.dx, detail.globalPosition.dy - 60);
    setState(() {
      nowPoints.add(p);
    });
  }

  void changeColor(Color c) {
    if (nowPoints.length != 0) {
      LinePoints l = LinePoints(new List<Offset>.from(nowPoints), nowColor);
      lines.add(l);
    }
    setState(() {
      nowPoints.clear();
      nowColor = c;
    });
  }

  List<Color> colors = <Color>[
    Colors.redAccent,
    Colors.pink,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.amber,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.cyanAccent,
  ];

  void _tapClear() {
    setState(() {
      lines.clear();
      nowPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pallet = <Widget>[];
    for (int i = 0; i < colors.length; i++) {
      Color c = colors[i];
      pallet.add(ColorPallet(
        color: c,
        changeColor: changeColor,
        isSelect: c == nowColor,
      ));
    }

    return new Scaffold(
      primary: false,
      body: new Container(
        decoration: BoxDecoration(color: Colors.white),
        child: new Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.black12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: pallet,
              ),
              height: 60.0,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: GestureDetector(
                  child: CustomPaint(
                    painter: PaintCanvas(lines, nowPoints, nowColor),
                  ),
                  onHorizontalDragUpdate: moveGestureDetector,
                  onVerticalDragUpdate: moveGestureDetector,
                  onHorizontalDragStart: newGestureDetector,
                  onVerticalDragStart: newGestureDetector,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tapClear,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.delete),
      ),
    );
  }
}

// 実際に描画するキャンバス
class PaintCanvas extends CustomPainter {
  final List<LinePoints> lines;
  final List<Offset> nowPoints;
  final Color nowColor;

  PaintCanvas(this.lines, this.nowPoints, this.nowColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    canvas.save();
    for (int i = 0; i < lines.length; i++) {
      LinePoints l = lines[i];
      for (int j = 1; j < l.points.length; j++) {
        Offset p1 = l.points[j - 1];
        Offset p2 = l.points[j];
        p.color = l.lineColor;
        canvas.drawLine(p1, p2, p);
      }
    }
    for (int i = 1; i < nowPoints.length; i++) {
      Offset p1 = nowPoints[i - 1];
      Offset p2 = nowPoints[i];
      p.color = nowColor;
      canvas.drawLine(p1, p2, p);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// 一筆書き分の座標を持つClass
class LinePoints {
  final List<Offset> points;
  final Color lineColor;

  LinePoints(this.points, this.lineColor);
}

// 色を変えるボタンClass
class ColorPallet extends StatelessWidget {
  final Color color;
  final Function changeColor;

  const ColorPallet({Key key, this.color, this.changeColor, this.isSelect})
      : super(key: key);
  final bool isSelect;

  void onPressed() {
    changeColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      onPressed: onPressed,
      constraints: BoxConstraints(minWidth: 60.0, minHeight: 50.0),
      child: new Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(
            color: Colors.white,
            width: isSelect ? 3.0 : 0.0,
          ),
        ),
      ),
    );
  }
}
