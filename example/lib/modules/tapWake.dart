import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class TapWakePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TapWakePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TapWakePage> createState() {
    return _TapWakePage();
  }
}

class _TapWakePage extends State<TapWakePage> {
  bool _enable = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Tap Wake"),
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
                  title: 'supported Contacts',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("enable: $_enable", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          bool enable = await widget.blePlugin.queryWakeState;
                          setState(() {
                            _enable = enable;
                          });
                        },
                        child: const Text("queryWakeState()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendWakeState(true), child: const Text("sendWakeState(true)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendWakeState(false), child: const Text("sendWakeState(false)"))
                  ])
            ]))));
  }
}
