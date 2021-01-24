import 'package:flutter/material.dart';

const owl_url =
    'https://raw.githubusercontent.com/flutter/website/master/src/images/owl.jpg';

class FadeInDemo extends StatefulWidget {
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> {
  double opacityLevel = 0.0;

  getText() {
    if (opacityLevel == 0) {
      return 'Show details';
    } else {
      return 'Hide details';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dialog Demo')),
      body: Column(children: <Widget>[
        Image.network(owl_url),
        TextButton(
          child: Text(
            getText(),
            style: TextStyle(color: Colors.blueAccent),
          ),
          onPressed: () => setState(() {
            if (opacityLevel == 0) {
              opacityLevel = 1.0;
            } else {
              opacityLevel = 0.0;
            }
          }),
        ),
        AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: opacityLevel,
          child: Column(
            children: <Widget>[
              Text('Type: Owl'),
              Text('Age: 39'),
              Text('Employment: None'),
            ],
          ),
        )
      ]),
    );
  }
}
