import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class SOSPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SOSPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SOSPage();
  }
}

class _SOSPage extends State<SOSPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _sosState = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.sosChangeEveStm.listen(
        (dynamic event) {
          if (!mounted) return;
          setState(() {
            _sosState = event;
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
          title: const Text("SOS"),
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
                title: 'sos',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  const Text("Only supported by some watches", style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                  Text("_sosState: $_sosState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey))
                ])
          ]),
        ),
      ),
    );
  }
}
