import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BodyTemperaturePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BodyTemperaturePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BodyTemperaturePage> createState() {
    return _BodyTemperaturePage();
  }
}

class _BodyTemperaturePage extends State<BodyTemperaturePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _enable = false;
  double _temp = -1.0;
  bool _state = false;
  TempInfo? _tempInfo;
  String _tempTimeType = "";
  int _startTime = -1;
  List<double> _tempList = [];
  String _timingMeasureTempState = '';
  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.tempChangeEveStm.listen(
        (TempChangeBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case TempChangeType.continueState:
                _enable = event.enable!;
                break;
              case TempChangeType.measureTemp:
                _temp = event.temp!;
                break;
              case TempChangeType.measureState:
                _state = event.state!;
                break;
              case TempChangeType.continueTemp:
                _tempInfo = event.tempInfo;
                _tempTimeType = _tempInfo!.tempTimeType!;
                _startTime = _tempInfo!.startTime!;
                _tempList = _tempInfo!.tempList!;
                break;
              default:
                break;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Body Temperature"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(
                child: ListView(children: <Widget>[
              CustomGestureDetector(
                  title: 'Measure Temp',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("temp: $_temp", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("state: $_state", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.startMeasureTemp, child: const Text("startMeasureTemp()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.stopMeasureTemp, child: const Text("stopMeasureTemp()")),
                  ]),
              CustomGestureDetector(
                  title: 'Timing Measure Temp',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    ElevatedButton(onPressed: () => widget.blePlugin.enableTimingMeasureTemp, child: const Text("enableTimingMeasureTemp()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.disableTimingMeasureTemp, child: const Text("disableTimingMeasureTemp()")),
                    Text("timingMeasureTempState: $_timingMeasureTempState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          String timingMeasureTempState = await widget.blePlugin.queryTimingMeasureTempState;
                          setState(() {
                            _timingMeasureTempState = timingMeasureTempState;
                          });
                        },
                        child: const Text("queryTimingMeasureTempState()")),

                    /// 需要核对sdk是否有该回调
                    const Text("Need to check whether the SDK has this callback",
                        style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.queryTimingMeasureTemp(TempTimeType.yesterday),
                        child: const Text("queryTimingMeasureTemp()")),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.queryTimingMeasureTemp(TempTimeType.today), child: const Text("queryTimingMeasureTemp()")),
                  ]),
              CustomGestureDetector(
                  title: 'Continue Timing Measure Temp',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState3 = newDisplayState;
                    });
                  },
                  displayState: displayState3,
                  children: <Widget>[
                    ElevatedButton(onPressed: () => widget.blePlugin.enableContinueTemp, child: const Text("enableContinueTemp")),
                    ElevatedButton(onPressed: () => widget.blePlugin.disableContinueTemp, child: const Text("disableContinueTemp")),
                    Text("enable: $_enable", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.queryContinueTempState, child: const Text("queryContinueTempState")),
                    Text("tempTimeType: $_tempTimeType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startTime: $_startTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("tempList: $_tempList", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.queryLast24HourTemp, child: const Text("queryLast24HourTemp")),
                  ])
            ]))));
  }
}
