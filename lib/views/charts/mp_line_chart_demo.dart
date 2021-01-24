import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'action_state.dart';

class MpLineChartDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MpLineChartDemoState();
  }
}

class MpLineChartDemoState extends SimpleActionState<MpLineChartDemo> {
  LineChartController _controller;
  var random = Random(1);
  double _range = 100.0;
  int _count = 0;

  @override
  void initState() {
    _initController();
    _initLineData(_range);
    super.initState();
  }

  @override
  String getTitle() => "Line Chart Performance";

  @override
  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 100,
            child: LineChart(_controller)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _range,
                            min: 0,
                            max: 9000,
                            onChanged: (value) {
                              _range = value;
                              _initLineData(_range);
                            })),
                  ),
                  Container(
                      constraints: BoxConstraints.expand(height: 50, width: 60),
                      padding: EdgeInsets.only(right: 15.0),
                      child: Center(
                          child: Text(
                        "$_count",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ))),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void _initController() {
    var desc = Description()..enabled = false;
    _controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.drawGridLines = (false);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          legend.enabled = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..drawGridLines = (true)
            ..drawAxisLine = (false);
        },
        drawGridBackground: true,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        autoScaleMinMaxEnabled: false,
        description: desc);
  }

  void _initLineData(double range) {
    // create set 1 data
    List<Entry> values1 = [];

    _count = (range + 1000).toInt();

    for (int i = 0; i < _count; i++) {
      double val = (random.nextDouble() * (range + 1)) + 100;
      values1.add(Entry(x: i * 0.001, y: val));
    }

    // create a dataset and give it a type
    LineDataSet set1 = new LineDataSet(values1, "DataSet 1");

    set1.setColor1(ColorUtils.RED);
    set1.setLineWidth(0.5);
    set1.setDrawValues(false);
    set1.setDrawCircles(false);
    set1.setMode(Mode.LINEAR);
    set1.setDrawFilled(true);
    set1.setFillColor(ColorUtils.HOLO_RED_LIGHT);

    // create set 2 data
    List<Entry> values2 = [];
    values2.clear();
    for (int i = 0; i < _count; i++) {
      double val = (random.nextDouble() * (range + 1)) + 2000;
      values2.add(Entry(x: i * 0.001, y: val));
    }

    LineDataSet set2 = new LineDataSet(values2, "DataSet 2");

    set2.setColor1(ColorUtils.HOLO_ORANGE_LIGHT);
    set2.setLineWidth(0.5);
    set2.setDrawValues(false);
    set2.setDrawCircles(false);
    set2.setMode(Mode.LINEAR);
    set2.setDrawFilled(true);

    // create a data object with the data sets
    List<ILineDataSet> dataSets = [];
    dataSets..add(set1)..add(set2);
    _controller.data = LineData.fromList(dataSets);

    setState(() {});
  }
}
