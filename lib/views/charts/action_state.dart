import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_basics/common/util.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';

PopupMenuItem item(String text, String id) {
  return PopupMenuItem<String>(
      value: id,
      child: Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Center(
              child: Text(
            text,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorUtils.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ))));
}

abstract class ActionState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                itemBuilder: getBuilder(),
                onSelected: (String action) {
                  itemClick(action);
                },
              ),
            ],
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(getTitle())),
        body: getBody());
  }

  void itemClick(String action);

  Widget getBody();

  String getTitle();

  PopupMenuItemBuilder<String> getBuilder();

  void captureImg(CaptureCallback callback) {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((permission) {
      if (permission.value != PermissionStatus.granted.value) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((permissions) {
          if (permissions.containsKey(PermissionGroup.storage)) {
            if (permissions[PermissionGroup.storage] ==
                    PermissionStatus.granted ||
                ((permissions[PermissionGroup.storage] ==
                        PermissionStatus.unknown) &&
                    Platform.isIOS)) {
              callback();
            }
          }
        });
      } else {
        callback();
      }
    });
  }
}

typedef CaptureCallback = void Function();

abstract class SimpleActionState<T extends StatefulWidget>
    extends ActionState<T> {
  @override
  void itemClick(String action) {
    Util.openGithub();
  }

  @override
  getBuilder() {
    return (BuildContext context) =>
        <PopupMenuItem<String>>[item('View on GitHub', 'A')];
  }
}

abstract class BarActionState<T extends StatefulWidget> extends ActionState<T> {
  BarChartController controller;

  @override
  getBuilder() {
    return (BuildContext context) => <PopupMenuItem<String>>[
          item('View on GitHub', 'A'),
          item('Toggle Bar Borders', 'B'),
          item('Toggle Values', 'C'),
          item('Toggle Icons', 'D'),
          item('Toggle Highlight', 'E'),
          item('Toggle PinchZoom', 'F'),
          item('Toggle Auto Scale', 'G'),
          item('Animate X', 'H'),
          item('Animate Y', 'I'),
          item('Animate XY', 'J'),
          item('Save to Gallery', 'K'),
        ];
  }

  @override
  void itemClick(String action) {
    if (controller.state == null) {
      return;
    }

    switch (action) {
      case 'A':
        Util.openGithub();
        break;
      case 'B':
        for (IBarDataSet set in controller.data.dataSets)
          (set as BarDataSet)
              .setBarBorderWidth(set.getBarBorderWidth() == 1.0 ? 0.0 : 1.0);
        controller.state.setStateIfNotDispose();
        break;
      case 'C':
        for (IDataSet set in controller.data.dataSets)
          set.setDrawValues(!set.isDrawValuesEnabled());
        controller.state.setStateIfNotDispose();
        break;
      case 'D':
        List<IBarDataSet> sets = controller.data.dataSets;
        for (IBarDataSet iSet in sets) {
          BarDataSet set = iSet as BarDataSet;
          set.setDrawIcons(!set.isDrawIconsEnabled());
        }
        controller.state.setStateIfNotDispose();
        break;
      case 'E':
        if (controller.data != null) {
          controller.data
              .setHighlightEnabled(!controller.data.isHighlightEnabled());
          controller.state.setStateIfNotDispose();
        }
        break;
      case 'F':
        controller.pinchZoomEnabled = !controller.pinchZoomEnabled;
        controller.state.setStateIfNotDispose();
        break;
      case 'G':
        controller.autoScaleMinMaxEnabled = !controller.autoScaleMinMaxEnabled;
        controller.state.setStateIfNotDispose();
        break;
      case 'H':
        controller.animator
          ..reset()
          ..animateX1(2000);
        break;
      case 'I':
        controller.animator
          ..reset()
          ..animateY1(2000);
        break;
      case 'J':
        controller.animator
          ..reset()
          ..animateXY1(2000, 2000);
        break;
      case 'K':
        captureImg(() {
          controller.state.capture();
        });
        break;
    }
  }
}
