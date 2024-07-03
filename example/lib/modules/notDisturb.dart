import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class NotDisturbPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotDisturbPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<NotDisturbPage> createState() {
    return _NotDisturbPage();
  }
}

class _NotDisturbPage extends State<NotDisturbPage> {
  PeriodTimeResultBean? _periodTimeResultBean;
  int _periodTimeType = -1;
  PeriodTimeBean? _periodTimeInfo;
  int _endHour = -1;
  int _endMinute = -1;
  int _startHour = -1;
  int _startMinute = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Not Disturb"),
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
                  title: 'Not Disturb',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("periodTimeType: $_periodTimeType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startHour: $_startHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startMinute: $_startMinute", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("endHour: $_endHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("endMinute: $_endMinute", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryDoNotDisturbTime()'),
                        onPressed: () async {
                          _periodTimeResultBean = await widget.blePlugin.queryDoNotDisturbTime;
                          setState(() {
                            _periodTimeType = _periodTimeResultBean!.periodTimeType;
                            _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                            _endHour = _periodTimeInfo!.endHour;
                            _endMinute = _periodTimeInfo!.endMinute;
                            _startHour = _periodTimeInfo!.startHour;
                            _startMinute = _periodTimeInfo!.startMinute;
                          });
                        }),
                    ElevatedButton(
                        child: const Text('sendDoNotDisturbTime()'),
                        onPressed: () =>
                            widget.blePlugin.sendDoNotDisturbTime(PeriodTimeBean(startHour: 1, endHour: 1, startMinute: 1, endMinute: 1))),
                    ElevatedButton(
                        child: const Text('sendDoNotDisturbTime()'),
                        onPressed: () =>
                            widget.blePlugin.sendDoNotDisturbTime(PeriodTimeBean(startHour: 2, endHour: 2, startMinute: 2, endMinute: 2)))
                  ])
            ]))));
  }
}
