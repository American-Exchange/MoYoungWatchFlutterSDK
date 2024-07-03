import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class CalendarEventPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const CalendarEventPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalendarEventPage();
  }
}

class _CalendarEventPage extends State<CalendarEventPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _maxNumber = -1;
  List<SavedCalendarEventInfoBean> _list = [];
  CalendarEventInfoBean _calendarEventInfo =
      CalendarEventInfoBean(id: -1, title: "", startHour: -1, startMinute: -1, endHour: -1, endMinute: -1, time: -1);
  bool _state = false;
  int _time = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.calendarEventEveStem.listen(
        (CalendarEventBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case CalendarEventType.support:
                _maxNumber = event.maxNumber;
                _list = event.list;
                break;
              case CalendarEventType.details:
                _calendarEventInfo = event.calendarEventInfo;
                break;
              case CalendarEventType.stateAndTime:
                _state = event.state;
                _time = event.time;
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
          title: const Text("Calendar Event"),
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
                title: 'Calendar',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  Text("maxNumber: $_maxNumber", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  Text("list: $_list", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.querySupportCalendarEvent, child: const Text("querySupportCalendarEvent")),
                  Text("calendarEventInfo: ${calendarEventInfoBeanToJson(_calendarEventInfo)}", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.queryCalendarEvent(1);
                      },
                      child: const Text("queryCalendarEvent")),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.sendCalendarEvent(CalendarEventInfoBean(
                          id: 1,
                          title: "生日",
                          startHour: 2,
                          startMinute: 30,
                          endHour: 4,
                          endMinute: 30,
                          time: 40,
                        ));
                      },
                      child: const Text("sendCalendarEvent")),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.deleteCalendarEvent(1);
                      },
                      child: const Text("deleteCalendarEvent")),
                  Text("state: $_state", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  Text("time: $_time", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(
                      onPressed: () => widget.blePlugin.queryCalendarEventReminderTime, child: const Text("queryCalendarEventReminderTime")),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.sendCalendarEventReminderTime(CalendarEventReminderTimeBean(
                          enable: true,
                          minutes: 30,
                        ));
                      },
                      child: const Text("sendCalendarEventReminderTime")),
                  ElevatedButton(onPressed: () => widget.blePlugin.clearCalendarEvent, child: const Text("clearCalendarEvent"))
                ])
          ]),
        ),
      ),
    );
  }
}
