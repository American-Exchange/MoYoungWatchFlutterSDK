import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class SleepPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SleepPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SleepPage> createState() {
    return _SleepPage();
  }
}

class _SleepPage extends State<SleepPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _totalTime = -1;
  int _restfulTime = -1;
  int _lightTime = -1;
  int _soberTime = -1;
  int _remTime = -1;
  int _timeType = -1;
  List<DetailBean> _details = [];

  SleepInfo? sleepInfo;
  HistorySleepBean? historySleep;

  int _goalSleepTime = -1;

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.sleepChangeEveStm.listen(
        (SleepBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case SleepType.sleepChange:
                _totalTime = event.sleepInfo!.totalTime!;
                _restfulTime = event.sleepInfo!.restfulTime!;
                _lightTime = event.sleepInfo!.lightTime!;
                _soberTime = event.sleepInfo!.soberTime!;
                _remTime = event.sleepInfo!.remTime!;
                _details = event.sleepInfo!.details;
                break;
              case SleepType.historySleepChange:
                _timeType = event.historySleep!.timeType!;
                _totalTime = event.historySleep!.sleepInfo!.totalTime!;
                _restfulTime = event.historySleep!.sleepInfo!.restfulTime!;
                _lightTime = event.historySleep!.sleepInfo!.lightTime!;
                _soberTime = event.historySleep!.sleepInfo!.soberTime!;
                _remTime = event.historySleep!.sleepInfo!.remTime!;
                _details = event.historySleep!.sleepInfo!.details;
                break;
              case SleepType.goalSleepTimeChange:
                _goalSleepTime = event.goalSleepTime!;
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
              title: const Text("Sleep"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(
              child: ListView(
                children: [
                  CustomGestureDetector(
                      title: 'querySleep',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        Text("timeType: $_timeType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("totalTime: $_totalTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("restfulTime: $_restfulTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("lightTime: $_lightTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("soberTime: $_soberTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("remTime: $_remTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("details: ${_details.map((e) => detailBeanToJson(e))}",
                            style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(child: const Text('querySleep'), onPressed: () => widget.blePlugin.querySleep),
                        ElevatedButton(child: const Text('queryRemSleep'), onPressed: () => widget.blePlugin.queryRemSleep),
                        ElevatedButton(
                            child: const Text('queryHistorySleep(YESTERDAY)'),
                            onPressed: () => widget.blePlugin.queryHistorySleep(SleepHistoryTimeType.yesterday)),
                        ElevatedButton(
                            child: const Text('queryHistorySleep(THE_DAY_BEFORE_YESTERDAY)'),
                            onPressed: () => widget.blePlugin.queryHistorySleep(SleepHistoryTimeType.theDayBeforeYesterday)),
                      ]),
                  CustomGestureDetector(
                      title: 'queryGoalSleepTime',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState2 = newDisplayState;
                        });
                      },
                      displayState: displayState2,
                      children: <Widget>[
                        Text("goalSleepTime: $_goalSleepTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('sendGoalSleepTime'),

                            /// Must be a multiple of 10, with a maximum value of 750
                            onPressed: () => widget.blePlugin.sendGoalSleepTime(10)),
                        ElevatedButton(child: const Text('queryGoalSleepTime'), onPressed: () => widget.blePlugin.queryGoalSleepTime),
                      ])
                ],
              ),
            )));
  }
}
