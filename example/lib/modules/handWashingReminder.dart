import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class HandWashingReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HandWashingReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HandWashingReminderPage> createState() {
    return _HandWashingReminderPage();
  }
}

class _HandWashingReminderPage extends State<HandWashingReminderPage> {
  HandWashingPeriodBean? _handWashingPeriodBean;
  bool _enable = false;
  int _startHour = -1;
  int _startMinute = -1;
  int _count = -1;
  int _period = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hand Washing Reminder"),
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
                  title: 'Hand Washing Reminder',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("enable: $_enable", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startHour: $_startHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startMinute: $_startMinute", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("count: $_count", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("period: $_period", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          _handWashingPeriodBean = await widget.blePlugin.queryHandWashingReminderPeriod;
                          setState(() {
                            _enable = _handWashingPeriodBean!.enable;
                            _startHour = _handWashingPeriodBean!.startHour;
                            _startMinute = _handWashingPeriodBean!.startMinute;
                            _count = _handWashingPeriodBean!.count;
                            _period = _handWashingPeriodBean!.period;
                          });
                        },
                        child: const Text("queryHandWashingReminderPeriod()")),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.enableHandWashingReminder(HandWashingPeriodBean(
                              enable: true,
                              startHour: 1,
                              startMinute: 1,
                              count: 1,
                              period: 1,
                            )),
                        child: const Text("enableHandWashingReminder()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.disableHandWashingReminder, child: const Text("disableHandWashingReminder()"))
                  ])
            ]))));
  }
}
