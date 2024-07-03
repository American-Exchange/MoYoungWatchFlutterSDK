import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class HeartRateAlarmPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HeartRateAlarmPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HeartRateAlarmPage> createState() {
    return _HeartRateAlarmPage();
  }
}

class _HeartRateAlarmPage extends State<HeartRateAlarmPage> {
  MaxHeartRateBean? _maxHeartRateBean;
  int _heartRate = -1;
  bool _enable = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Heart Rate Alarm"),
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
                  title: 'Heart Rate Alarm',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("heartRate: $_heartRate", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("enable: $_enable", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setMaxHeartRate(MaxHeartRateBean(
                              heartRate: 100,
                              enable: true,
                            )),
                        child: const Text("setMaxHeartRate(100, true)")),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setMaxHeartRate(MaxHeartRateBean(
                              heartRate: 150,
                              enable: false,
                            )),
                        child: const Text("setMaxHeartRate(150, false)")),
                    ElevatedButton(
                        onPressed: () async {
                          _maxHeartRateBean = await widget.blePlugin.queryMaxHeartRate;
                          setState(() {
                            _enable = _maxHeartRateBean!.enable;
                            _heartRate = _maxHeartRateBean!.heartRate;
                          });
                        },
                        child: const Text("queryMaxHeartRate()"))
                  ])
            ]))));
  }
}
