import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'dart:async';

import '../components/base/CustomGestureDetector.dart';

class HeartRatePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HeartRatePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<HeartRatePage> createState() {
    return _HearRatePage();
  }
}

class _HearRatePage extends State<HeartRatePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _measuring = -1;
  int _onceMeasureComplete = -1;
  List<HistoryHeartRateBean> _historyHrList = [];
  MeasureCompleteBean? _measureComplete = MeasureCompleteBean(
    historyDynamicRateType: "",
    heartRate: HeartRateInfo(heartRateType: '', heartRateList: [], timeInterval: -1, startTime: -1, isAllDay: 0),
  );
  final List<HeartRateInfo> _hour24MeasureResultList = [];
  List<TrainingHeartRateBean> _trainingList = [];
  int _timingMeasure = -1;
  int _averageHeartRate = -1;

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
      widget.blePlugin.heartRateEveStm.listen(
        (HeartRateBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case HeartRateType.measuring:
                _measuring = event.measuring!;
                break;
              case HeartRateType.onceMeasureComplete:
                _onceMeasureComplete = event.onceMeasureComplete!;
                break;
              case HeartRateType.heartRate:
                _historyHrList = event.historyHrList!;
                break;
              case HeartRateType.measureComplete:
                _measureComplete = event.measureComplete!;
                break;
              case HeartRateType.hourMeasureResult:
                _hour24MeasureResultList.add(event.hour24MeasureResult!);
                break;
              case HeartRateType.measureResult:
                if (event.trainingList!.isNotEmpty) {
                  _trainingList = event.trainingList!;
                } else {
                  _trainingList = [];
                }
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
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hear Rate"),
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
                  title: 'queryLastDynamicRate',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("measuring: $_measuring", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("measureComplete: ${measureCompleteBeanToJson(_measureComplete!)}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryLastDynamicRate(firstHeartRate)'),
                        onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.firstHeartRate)),
                    ElevatedButton(
                        child: const Text('queryLastDynamicRate(secondHeartRate)'),
                        onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.secondHeartRate)),
                    ElevatedButton(
                        child: const Text('queryLastDynamicRate(thirdHeartRate)'),
                        onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.thirdHeartRate))
                  ]),
              CustomGestureDetector(
                  title: 'queryTimingMeasureHeartRate',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    Text("timingMeasure: $_timingMeasure", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    const Text("The interval is in units of 5", style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    ElevatedButton(
                        child: const Text('enableTimingMeasureHeartRate(5)'), onPressed: () => widget.blePlugin.enableTimingMeasureHeartRate(5)),
                    ElevatedButton(
                        child: const Text('disableTimingMeasureHeartRate()'), onPressed: () => widget.blePlugin.disableTimingMeasureHeartRate),
                    ElevatedButton(
                        child: const Text('queryTimingMeasureHeartRate()'),
                        onPressed: () async {
                          int timingMeasure = await widget.blePlugin.queryTimingMeasureHeartRate;
                          setState(() {
                            _timingMeasure = timingMeasure;
                          });
                        }),
                  ]),
              CustomGestureDetector(
                  title: 'ALL HeartRate',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState3 = newDisplayState;
                    });
                  },
                  displayState: displayState3,
                  children: <Widget>[
                    Text("_hour24MeasureResult: ${_hour24MeasureResultList.map((value) => heartRateInfoToJson(value))}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryTodayHeartRate(TIMING_MEASURE_HEART_RATE)'),
                        onPressed: () => widget.blePlugin.queryTodayHeartRate(TodayHeartRateType.timingMeasureHeartRate)),
                    ElevatedButton(
                        child: const Text('queryTodayHeartRate(ALL_DAY_HEART_RATE)'),
                        onPressed: () {
                          _hour24MeasureResultList.clear();
                          widget.blePlugin.queryTodayHeartRate(TodayHeartRateType.allDayHeartRate);
                        }),
                    ElevatedButton(
                        child: const Text('queryPastHeartRate'),
                        onPressed: () => widget.blePlugin.queryPastHeartRate(HistoryHeartRateDay.historyDay)),
                    Text("trainingList: ${_trainingList.map((value) => trainingHeartRateBeanToJson(value))}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      child: const Text('queryTrainingHeartRate'),
                      onPressed: () => widget.blePlugin.queryTrainingHeartRate,
                    ),
                  ]),
              CustomGestureDetector(
                  title: 'Measure Once HeartRate',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState4 = newDisplayState;
                    });
                  },
                  displayState: displayState4,
                  children: <Widget>[
                    Text("measuring: $_measuring", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("onceMeasureComplete: $_onceMeasureComplete", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('startMeasureOnceHeartRate'), onPressed: () => widget.blePlugin.startMeasureOnceHeartRate),
                    ElevatedButton(child: const Text('stopMeasureOnceHeartRate'), onPressed: () => widget.blePlugin.stopMeasureOnceHeartRate),
                    Text("historyHrList: $_historyHrList", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryHistoryHeartRate'), onPressed: () => widget.blePlugin.queryHistoryHeartRate),
                    const Text("Only For debugging, manual modification is required",
                        style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    Text("_averageHeartRate: $_averageHeartRate", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      onPressed: () async {
                        int averageHeartRate = await widget.blePlugin.queryAverageHeartRate(1681488040, 1681488340, []);
                        setState(() {
                          _averageHeartRate = averageHeartRate;
                        });
                      },
                      child: const Text('queryAverageHeartRate'),
                    )
                  ])
            ]))));
  }
}
