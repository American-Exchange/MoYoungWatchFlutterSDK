import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class RSSIPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const RSSIPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<RSSIPage> createState() {
    return _RSSIPage();
  }
}

class _RSSIPage extends State<RSSIPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _deviceRssi = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.deviceRssiEveStm.listen(
        (int event) {
          if (!mounted) return;
          setState(() {
            _deviceRssi = event;
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
              title: const Text("RSSI"),
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
                  title: 'RSSI',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("deviceRssi: $_deviceRssi", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('readDeviceRssi'), onPressed: () => widget.blePlugin.readDeviceRssi)
                  ])
            ]))));
  }
}
