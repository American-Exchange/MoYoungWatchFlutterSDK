import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BatterySavingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BatterySavingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatterySavingPage> createState() {
    return _BatterySavingPage();
  }
}

class _BatterySavingPage extends State<BatterySavingPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _batterSaving = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.batterySavingEveStm.listen(
        (bool event) {
          if (!mounted) return;
          setState(() {
            _batterSaving = event;
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
              title: const Text("Battery Saving"),
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
                  title: 'Batter Saving',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("batterSaving: $_batterSaving", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendBatterySaving(true), child: const Text("sendBatterySaving(true)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendBatterySaving(false), child: const Text("sendBatterySaving(false)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.queryBatterySaving, child: const Text("queryBatterySaving()"))
                  ])
            ]))));
  }
}
