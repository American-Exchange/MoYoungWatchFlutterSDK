import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class FindPhonePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindPhonePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<FindPhonePage> createState() {
    return _FindPhonePage();
  }
}

class _FindPhonePage extends State<FindPhonePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String findState = '';
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.findPhoneEveStm.listen(
        (FindPhoneBean event) {
          switch (event.type) {
            case FindPhoneType.find:
              setState(() {
                findState = 'finding';
              });
              break;
            case FindPhoneType.complete:
              setState(() {
                findState = 'completed';
              });
              break;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Phone"),
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
                  title: 'Find Phone',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("findState:$findState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.startFindPhone, child: const Text('startFindPhone()')),
                    ElevatedButton(onPressed: () => widget.blePlugin.stopFindPhone, child: const Text("stopFindPhone()"))
                  ])
            ]))));
  }
}
