import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class SedentaryReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SedentaryReminderPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SedentaryReminderPage> createState() {
    return _SedentaryReminderPage();
  }
}

class _SedentaryReminderPage extends State<SedentaryReminderPage> {
  bool _sedentaryReminder = false;
  SedentaryReminderPeriodBean? _reminderPeriodBean;
  int _endHour = -1;
  int _period = -1;
  int _startHour = -1;
  int _steps = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Sedentary Reminder"),
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
                  title: 'Sedentary Reminder',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("sedentaryReminder: $_sedentaryReminder", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('sendSedentaryReminder(false)'), onPressed: () => widget.blePlugin.sendSedentaryReminder(false)),
                    ElevatedButton(child: const Text('sendSedentaryReminder(true)'), onPressed: () => widget.blePlugin.sendSedentaryReminder(true)),
                    ElevatedButton(
                        child: const Text('querySedentaryReminder()'),
                        onPressed: () async {
                          bool sedentaryReminder = await widget.blePlugin.querySedentaryReminder;
                          setState(() {
                            _sedentaryReminder = sedentaryReminder;
                          });
                        }),
                    Text("endHour: $_endHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("period: $_period", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("startHour: $_startHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("steps: $_steps", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('sendSedentaryReminderPeriod()'),
                        onPressed: () => widget.blePlugin
                            .sendSedentaryReminderPeriod(SedentaryReminderPeriodBean(startHour: 10, endHour: 20, period: 3, steps: 10))),
                    ElevatedButton(
                        child: const Text('sendSedentaryReminderPeriod()'),
                        onPressed: () => widget.blePlugin
                            .sendSedentaryReminderPeriod(SedentaryReminderPeriodBean(startHour: 20, endHour: 10, period: 2, steps: 40))),
                    ElevatedButton(
                        child: const Text('querySedentaryReminderPeriod()'),
                        onPressed: () async {
                          _reminderPeriodBean = await widget.blePlugin.querySedentaryReminderPeriod;
                          setState(() {
                            _endHour = _reminderPeriodBean!.endHour;
                            _period = _reminderPeriodBean!.period;
                            _startHour = _reminderPeriodBean!.startHour;
                            _steps = _reminderPeriodBean!.steps;
                          });
                        })
                  ])
            ]))));
  }
}
