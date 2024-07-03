import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class HRVPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HRVPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HRVPage();
  }
}

class _HRVPage extends State<HRVPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _isSupport = false;
  int _value = -1;
  List<HistoryHrvInfoBean> _list = [];
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.newHrvEveStm.listen(
        (HrvHandlerBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case HRVType.support:
                _isSupport = event.isSupport;
                break;
              case HRVType.hrv:
                _value = event.value;
                break;
              case HRVType.history:
                _list = event.list;
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
          title: const Text("HRV"),
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
                title: 'HRV',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  Text("isSupport: $_isSupport", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.querySupportNewHrv, child: const Text("querySupportNewHrv")),
                  Text("value: $_value", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.startMeasureNewHrv, child: const Text("startMeasureNewHrv")),
                  ElevatedButton(onPressed: () => widget.blePlugin.stopMeasureNewHrv, child: const Text("stopMeasureNewHrv")),
                  Text("list: $_list", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(onPressed: () => widget.blePlugin.queryHistoryNewHrv, child: const Text("queryHistoryNewHrv"))
                ])
          ]),
        ),
      ),
    );
  }
}
