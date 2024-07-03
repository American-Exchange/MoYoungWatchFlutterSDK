import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'dart:async';

import '../components/base/CustomGestureDetector.dart';

class StepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const StepsPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<StepsPage> createState() {
    return _StepsPage();
  }
}

class _StepsPage extends State<StepsPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String stepsInfo = "";
  String historyStepsInfo = "";
  String list = "";
  String stepsCategoryInfo = "";
  String actionDetailsInfo = "";
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
      widget.blePlugin.stepsChangeEveStm.listen(
        (StepsChangeBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StepsChangeType.stepChange:
                stepsInfo = stepInfoBeanToJson(event.stepsInfo!);
                break;
              case StepsChangeType.historyStepChange:
                historyStepsInfo = historyStepInfoBeanToJson(event.historyStepsInfo!);
                break;
              default:
                break;
            }
          });
        },
      ),
    );

    _streamSubscriptions.add(
      widget.blePlugin.stepsDetailEveStm.listen(
        (StepsDetailBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StepsDetailType.stepsCategoryChange:
                stepsCategoryInfo = stepsCategoryBeanToJson(event.stepsCategoryInfo!);
                break;
              case StepsDetailType.actionDetailsChange:
                actionDetailsInfo = actionDetailsBeanToJson(event.actionDetailsInfo!);
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
              title: const Text("Steps"),
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
                  // Text("list: $list"),
                  CustomGestureDetector(
                      title: 'StepsInfo',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        Text("stepsInfo: $stepsInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(child: const Text('querySteps'), onPressed: () => widget.blePlugin.querySteps)
                      ]),
                  CustomGestureDetector(
                      title: 'queryHistorySteps',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState2 = newDisplayState;
                        });
                      },
                      displayState: displayState2,
                      children: <Widget>[
                        Text("historyStepsInfo: $historyStepsInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('queryHistorySteps(yesterday)'),
                            onPressed: () => widget.blePlugin.queryHistorySteps(StepsDetailDateType.yesterday)),

                        /// 获取步数历史记录
                        ElevatedButton(
                            child: const Text('queryHistorySteps(theDayBeforeYesterday)'),
                            onPressed: () => widget.blePlugin.queryHistorySteps(StepsDetailDateType.theDayBeforeYesterday)),
                      ]),
                  CustomGestureDetector(
                      title: 'queryStepsDetail',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState3 = newDisplayState;
                        });
                      },
                      displayState: displayState3,
                      children: <Widget>[
                        Text("stepsCategoryInfo: $stepsCategoryInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("actionDetailsInfo: $actionDetailsInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),

                        /// 获取最近两天步数半小时分类统计
                        ElevatedButton(
                            child: const Text('queryStepsDetail(today)'),
                            onPressed: () => widget.blePlugin.queryStepsDetail(StepsDetailDateType.today)),
                      ])
                ],
              ),
            )));
  }
}
