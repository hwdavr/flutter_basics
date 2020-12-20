import 'package:flutter/material.dart';
import 'package:flutter_basics/views/button_demo.dart';
import 'package:flutter_basics/views/dialog_demo.dart';
import 'package:flutter_basics/views/future_demo.dart';
import 'package:flutter_basics/views/image_picker.dart';
import 'package:flutter_basics/views/iosolate_demo.dart';
import 'package:flutter_basics/views/text_demo.dart';

void main() {
  runApp(FlutterDemoApp());
}

class FlutterDemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(title: 'My Flutter Demo'),
        routes: {
          'text': (context) => TextPage(),
          'button': (context) => ButtonPage(),
          'image_picker': (context) => ImagePickerPage()
        });
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(title: Text('Text'), onTap: () => _navigateByName('text')),
            ListTile(
                title: Text('Button'), onTap: () => _navigateByName('button')),
            ListTile(
              title: Text('Dialog'),
              onTap: () => _navigateByRoute(DialogPage()),
            ),
            ListTile(
              title: Text('Image Picker'),
              onTap: () => _navigateByRoute(ImagePickerPage()),
            ),
            ListTile(
              title: Text('Future'),
              onTap: () => _navigateByRoute(FuturePage()),
            ),
            ListTile(
              title: Text('Isolate'),
              onTap: () => _navigateByRoute(IsolatePage()),
            )
          ]).toList(),
        ));
  }

  _navigateByName(String page) {
    Navigator.pushNamed(context, page);
  }

  _navigateByRoute(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
