import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:isolate';

class IsolatePage extends StatefulWidget {
  IsolatePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IsolatePageState createState() => new _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;

  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    // Spawn the Isolate
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      // Send the message to MessageHandler
      sendPort.send(msg);
    });
  }

  // Handler to receive message
  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
    setState(() {
      notification = data;
    });
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
        notification = '';
      });
      _receivePort.close();
      // Kill the Isolate
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Isolate Demo'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '$notification',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _running ? _stop : _start,
        tooltip: _running ? 'Timer stop' : 'Timer start',
        child: _running ? new Icon(Icons.stop) : new Icon(Icons.play_arrow),
      ),
    );
  }
}
