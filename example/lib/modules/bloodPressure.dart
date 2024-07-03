import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BloodPressurePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodPressurePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<BloodPressurePage> createState() {
    return _BloodPressurePage();
  }
}

class _BloodPressurePage extends State<BloodPressurePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _continueState = false;
  BloodPressureChangeBean? _bean;
  int _systolicBloodPressure = -1;
  int _diastolicBloodPressure = -1;
  List<HistoryBloodPressureBean> _historyBpList = [];
  BloodPressureInfo? info;
  int _startTime = -1;
  int _timeInterval = -1;
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
      widget.blePlugin.bloodPressureEveStm.listen(
        (BloodPressureBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case BloodPressureType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodPressureType.pressureChange:
                _bean = event.pressureChange!;
                _systolicBloodPressure = _bean!.sbp!;
                _diastolicBloodPressure = _bean!.dbp!;
                break;
              case BloodPressureType.historyList:
                _historyBpList = event.historyBpList!;
                break;
              case BloodPressureType.continueBP:
                info = event.continueBp!;
                _startTime = info!.startTime!;
                _timeInterval = info!.timeInterval!;
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
              title: const Text("Blood Pressure"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(
                child: ListView(children: [
              CustomGestureDetector(
                  title: 'Blood Pressure',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("systolicBloodPressure: $_systolicBloodPressure", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("diastolicBloodPressure: $_diastolicBloodPressure", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('startMeasureBloodPressure'), onPressed: () => widget.blePlugin.startMeasureBloodPressure),
                    ElevatedButton(child: const Text('stopMeasureBloodPressure'), onPressed: () => widget.blePlugin.stopMeasureBloodPressure),
                  ]),
              CustomGestureDetector(
                  title: 'Continue Blood Pressure',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    ElevatedButton(child: const Text('enableContinueBloodPressure'), onPressed: () => widget.blePlugin.enableContinueBloodPressure),
                    ElevatedButton(child: const Text('disableContinueBloodPressure'), onPressed: () => widget.blePlugin.disableContinueBloodPressure),
                    Text("continueState: $_continueState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryContinueBloodPressureState'), onPressed: () => widget.blePlugin.queryContinueBloodPressureState),
                    Text("startTime: $_startTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("timeInterval: $_timeInterval", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryLast24HourBloodPressure'), onPressed: () => widget.blePlugin.queryLast24HourBloodPressure),
                  ]),
              CustomGestureDetector(
                  title: 'History Blood Pressure',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState3 = newDisplayState;
                    });
                  },
                  displayState: displayState3,
                  children: <Widget>[
                    Text("historyBpList[0]: $_historyBpList", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryHistoryBloodPressure'), onPressed: () => widget.blePlugin.queryHistoryBloodPressure),
                  ])
            ]))));
  }
}
