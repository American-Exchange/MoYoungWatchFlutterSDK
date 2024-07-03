import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class TimePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TimePage> createState() {
    return _TimePage();
  }
}

class _TimePage extends State<TimePage> {
  int _time = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Time"),
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
              title: 'Time',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState1 = newDisplayState;
                });
              },
              displayState: displayState1,
              children: <Widget>[
                ElevatedButton(child: const Text('queryTime()'), onPressed: () => widget.blePlugin.queryTime),
                Text("time: $_time", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text('queryTimeSystem()'),
                    onPressed: () async {
                      int time = await widget.blePlugin.queryTimeSystem;
                      setState(() {
                        _time = time;
                      });
                    }),
                ElevatedButton(
                    child: const Text('sendTimeSystem(TIME_SYSTEM_12)'),
                    onPressed: () => widget.blePlugin.sendTimeSystem(TimeSystemType.timeSystem12)),
                ElevatedButton(
                    child: const Text('sendTimeSystem(TIME_SYSTEM_24)'),
                    onPressed: () => widget.blePlugin.sendTimeSystem(TimeSystemType.timeSystem24)),
              ])
        ])),
      ),
    );
  }
}
