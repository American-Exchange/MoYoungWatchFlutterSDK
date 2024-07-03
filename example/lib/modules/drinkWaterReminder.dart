import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class DrinkWaterReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const DrinkWaterReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DrinkWaterReminderPage> createState() {
    return _DrinkWaterReminderPage();
  }
}

class _DrinkWaterReminderPage extends State<DrinkWaterReminderPage> {
  DrinkWaterPeriodBean? _drinkWaterPeriodBean;
  bool _enable = false;
  int _startHour = -1;
  int _startMinute = -1;
  int _count = -1;
  int _period = -1;
  int _currentCups = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Drink Water Reminder"),
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
                  title: 'Drink Water Reminder',
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
                    Text("currentCups: $_currentCups", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.enableDrinkWaterReminder(
                            DrinkWaterPeriodBean(enable: true, startHour: 1, startMinute: 1, count: 1, period: 1, currentCups: 1)),
                        child: const Text("enableDrinkWaterReminder()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.disableDrinkWaterReminder, child: const Text("disableDrinkWaterReminder()")),
                    ElevatedButton(
                        onPressed: () async {
                          _drinkWaterPeriodBean = await widget.blePlugin.queryDrinkWaterReminderPeriod;
                          setState(() {
                            _enable = _drinkWaterPeriodBean!.enable;
                            _startHour = _drinkWaterPeriodBean!.startHour;
                            _startMinute = _drinkWaterPeriodBean!.startMinute;
                            _count = _drinkWaterPeriodBean!.count;
                            _period = _drinkWaterPeriodBean!.period;
                            _currentCups = _drinkWaterPeriodBean!.currentCups;
                          });
                        },
                        child: const Text("queryDrinkWaterReminderPeriod()"))
                  ])
            ]))));
  }
}
