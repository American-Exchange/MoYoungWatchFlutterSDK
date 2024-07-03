import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class StressPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const StressPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StressPage();
  }
}

class _StressPage extends State<StressPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _isSupport = false;
  int _value = -1;
  List<HistoryStressInfoBean> _list = [];
  bool _state = false;
  TimingStressInfoBean _timingStressInfo = TimingStressInfoBean(date: StressDateBean(value: -1), list: []);
  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.stressEveStm.listen(
        (StressHandlerBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StressHandlerType.support:
                _isSupport = event.isSupport;
                break;
              case StressHandlerType.change:
                _value = event.value;
                break;
              case StressHandlerType.historyChange:
                _list = event.list;
                break;
              case StressHandlerType.timingStateChange:
                _state = event.state;
                break;
              case StressHandlerType.timingChange:
                _timingStressInfo = event.timingStressInfo;
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
          title: const Text("Stress"),
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
                title: 'Stress',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  Text("isSupport: $_isSupport", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.querySupportStress, child: const Text("querySupportStress")),
                  Text("value: $_value", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.startMeasureStress, child: const Text("startMeasureStress")),
                  ElevatedButton(onPressed: () => widget.blePlugin.stopMeasureStress, child: const Text("stopMeasureStress")),
                  Text("list: $_list", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.queryHistoryStress, child: const Text("queryHistoryStress")),
                ]),
            CustomGestureDetector(
                title: 'Timing Stress',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState2 = newDisplayState;
                  });
                },
                displayState: displayState2,
                children: <Widget>[
                  ElevatedButton(onPressed: () => widget.blePlugin.enableTimingStress, child: const Text("enableTimingStress")),
                  ElevatedButton(onPressed: () => widget.blePlugin.disableTimingStress, child: const Text("disableTimingStress")),
                  Text("state: $_state", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.queryTimingStressState, child: const Text("queryTimingStressState")),
                  Text("timingStressInfo: ${timingStressInfoBeanToJson(_timingStressInfo)}",
                      style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(
                      onPressed: () async {
                        await widget.blePlugin.queryTimingStress(StressDate.today);
                      },
                      child: const Text("queryTimingStress")),
                ])
          ]),
        ),
      ),
    );
  }
}
