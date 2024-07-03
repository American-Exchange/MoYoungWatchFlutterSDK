import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BloodOxygenPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodOxygenPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BloodOxygenPage> createState() {
    return _BloodOxygenPage();
  }
}

class _BloodOxygenPage extends State<BloodOxygenPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _continueState = false;
  int _timingMeasure = -1;
  int _bloodOxygen = -1;
  List<HistoryBloodOxygenBean> _historyList = [];
  BloodOxygenInfo? _continueBo;
  int _startTime = -1;
  int _timeInterval = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;
  CrossFadeState displayState4 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.bloodOxygenEveStm.listen(
        (BloodOxygenBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case BloodOxygenType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodOxygenType.timingMeasure:
                _timingMeasure = event.timingMeasure!;
                break;
              case BloodOxygenType.bloodOxygen:
                _bloodOxygen = event.bloodOxygen!;
                break;
              case BloodOxygenType.historyList:
                _historyList = event.historyList!;
                break;
              case BloodOxygenType.continueBO:
                _continueBo = event.continueBo!;
                _startTime = _continueBo!.startTime!;
                _timeInterval = _continueBo!.timeInterval!;
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
              title: const Text("Blood Oxygen"),
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
                  title: 'Blood Oxygen',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("bloodOxygen: $_bloodOxygen", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('startMeasureBloodOxygen'), onPressed: () => widget.blePlugin.startMeasureBloodOxygen),
                    ElevatedButton(child: const Text('stopMeasureBloodOxygen'), onPressed: () => widget.blePlugin.stopMeasureBloodOxygen),
                  ]),
              CustomGestureDetector(
                  title: 'Timing Blood Oxygen',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    const Text("The interval is in units of 5", style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    ElevatedButton(
                        child: const Text('enableTimingMeasureBloodOxygen(1)'), onPressed: () => widget.blePlugin.enableTimingMeasureBloodOxygen(1)),
                    ElevatedButton(
                        child: const Text('disableTimingMeasureBloodOxygen'), onPressed: () => widget.blePlugin.disableTimingMeasureBloodOxygen),
                    Text("timingMeasure: $_timingMeasure", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryTimingBloodOxygenMeasureState'),
                        onPressed: () => widget.blePlugin.queryTimingBloodOxygenMeasureState),
                    Text("startTime: $_startTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("timeInterval: $_timeInterval", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                        onPressed: () => widget.blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.today)),
                    ElevatedButton(
                        child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                        onPressed: () => widget.blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.yesterday)),
                  ]),
              CustomGestureDetector(
                  title: 'Continue Blood Oxygen',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState3 = newDisplayState;
                    });
                  },
                  displayState: displayState3,
                  children: <Widget>[
                    ElevatedButton(child: const Text('enableContinueBloodOxygen'), onPressed: () => widget.blePlugin.enableContinueBloodOxygen),
                    ElevatedButton(child: const Text('disableContinueBloodOxygen'), onPressed: () => widget.blePlugin.disableContinueBloodOxygen),
                    Text("continueState: $_continueState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryContinueBloodOxygenState'), onPressed: () => widget.blePlugin.queryContinueBloodOxygenState),
                    Text("startTime: $_startTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("timeInterval: $_timeInterval", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryLast24HourBloodOxygen'), onPressed: () => widget.blePlugin.queryLast24HourBloodOxygen),
                  ]),
              CustomGestureDetector(
                  title: 'History Blood Oxygen',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState4 = newDisplayState;
                    });
                  },
                  displayState: displayState4,
                  children: <Widget>[
                    Text("historyList: ${_historyList.map((e) => historyBloodOxygenBeanToJson(e))}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryHistoryBloodOxygen'), onPressed: () => widget.blePlugin.queryHistoryBloodOxygen),
                  ])
            ]))));
  }
}
