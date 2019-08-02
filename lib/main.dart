import 'package:flutter/material.dart';
import './draw.dart';

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

List<String> _logs = [];
bool isDebug = true;

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> createTextList(List<String> logs, {int lineCount: 15}) {
    if (logs.length > lineCount) {
      logs = logs.sublist(logs.length - lineCount, logs.length);
    }
    return logs.map((String log) => Text(log)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget note = Note();

    return Scaffold(
      body: Stack(
        children: [
          note,
          Container(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: createTextList(_logs),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
/*                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      note.currentPage.lines.clear();
                      _logs.add('clear');
                    });
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.arrow_left),
                  onPressed: () {
                    setState(() {
                      note.backPage();
                      _logs.add('clear');
                    });
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.arrow_right),
                  onPressed: () {
                    setState(() {
                      note.pushPage();
                      _logs.add('clear');
                    });
                  },
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
