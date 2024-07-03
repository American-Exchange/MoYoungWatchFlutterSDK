import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../Global.dart';
import '../components/base/CustomGestureDetector.dart';

class BatteryPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BatteryPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatteryPage> createState() {
    return _BatteryPage();
  }
}

class _BatteryPage extends State<BatteryPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _deviceBattery = -1;
  bool _subscribe = false;
  final MoYoungBle _blePlugin = Global.blePlugin;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.deviceBatteryEveStm.listen(
        (DeviceBatteryBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case DeviceBatteryType.deviceBattery:
                _deviceBattery = event.deviceBattery!;
                break;
              case DeviceBatteryType.subscribe:
                _subscribe = event.subscribe!;
                break;
              default:
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
              title: const Text("Battery"),
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
                  title: 'Battery',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("deviceBattery: $_deviceBattery", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('queryDeviceBattery()'), onPressed: () => _blePlugin.queryDeviceBattery),
                    Text("enable: $_subscribe", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('subscribeDeviceBattery()'), onPressed: () => _blePlugin.subscribeDeviceBattery),
                  ])
            ]))));
  }
}
