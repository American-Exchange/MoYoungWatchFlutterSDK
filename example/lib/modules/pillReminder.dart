import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class PillReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const PillReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<PillReminderPage> createState() {
    return _PillReminderPage();
  }
}

class _PillReminderPage extends State<PillReminderPage> {
  PillReminderCallback? _pillReminderCallback;
  int _supportCount = -1;
  int _id = -1;
  int _dateOffset = -1;
  String _name = "";
  int _repeat = -1;
  List<dynamic> _reminderTimeList = [];
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Pill Reminder"),
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
                  title: 'Pill Reminder',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("supportCount: $_supportCount", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("id: $_id", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("dateOffset: $_dateOffset", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("name: $_name", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("repeat: $_repeat", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("reminderTimeList: $_reminderTimeList", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          _pillReminderCallback = await widget.blePlugin.queryPillReminder;
                          setState(() {
                            _supportCount = _pillReminderCallback!.supportCount;
                            _id = _pillReminderCallback!.list[0].id;
                            _dateOffset = _pillReminderCallback!.list[0].dateOffset;
                            _name = _pillReminderCallback!.list[0].name;
                            _repeat = _pillReminderCallback!.list[0].repeat;
                            _reminderTimeList = _pillReminderCallback!.list[0].reminderTimeList;
                          });
                        },
                        child: const Text("queryPillReminder()")),
                    ElevatedButton(
                        onPressed: () =>
                            widget.blePlugin.sendPillReminder(PillReminderBean(id: 1, dateOffset: 1, name: "name", repeat: 1, reminderTimeList: [])),
                        child: const Text("sendPillReminder()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.deletePillReminder(1), child: const Text("deletePillReminder(1)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.clearPillReminder, child: const Text("clearPillReminder()"))
                  ])
            ]))));
  }
}
