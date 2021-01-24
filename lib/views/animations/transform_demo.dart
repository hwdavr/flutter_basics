import 'package:flutter/material.dart';
import 'dart:math' as math;

const owl_url =
    'https://raw.githubusercontent.com/flutter/website/master/src/images/owl.jpg';

class TransformDemo extends StatefulWidget {
  _TransformDemoState createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo>
    with SingleTickerProviderStateMixin {
  // Using the SingleTickerProviderStateMixin can ensure that our
  // AnimationController only animates while the Widget is visible on the
  // screen. This is a useful optimization that saves resources when the
  // Widget is not visible.

  static Matrix4 _pmat(num pv) {
    return new Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, pv * 0.001, //
      0.0, 0.0, 0.0, 1.0,
    );
  }

  Matrix4 perspective = _pmat(1.0);
  var degree = 0.0;

  static const Duration _duration = Duration(seconds: 5);
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, lowerBound: 0, upperBound: 360.0, duration: _duration)
      // The Widget's build needs to be called every time the animation's
      // value changes. So add a listener here that will call setState()
      // and trigger the build() method to be called by the framework.
      // If your Widget's build is relatively simple, this is a good option.
      // However, if your build method returns a tree of child Widgets and
      // most of them are not animated you should consider using
      // AnimatedBuilder instead.
      ..addListener(() {
        setState(() {
          degree = controller.value;
        });
      });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
    // controller.forward();
  }

  @override
  void dispose() {
    // AnimationController is a stateful resource that needs to be disposed when
    // this State gets disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Dialog Demo')),
        body: Center(
          child: Column(
            children: [
              Text(
                'OWL',
                style: Theme.of(context).textTheme.headline4,
              ),
              Transform(
                  //child: Image.asset('assets/img/star.png'),
                  child: Image.network(
                    owl_url,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        controller.forward();
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  alignment: FractionalOffset.center,
                  transform: perspective.scaled(1.0, 1.0, 1.0)
                    ..rotateX(0.0)
                    ..rotateY(degree * math.pi / 180)
                    ..rotateZ(0.0)),
            ],
          ),
        ));
  }
}
