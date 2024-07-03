import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class ECGPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ECGPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ECGPage> createState() {
    return _ECGPage();
  }
}

class _ECGPage extends State<ECGPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<int> _ints = [];
  String _date = "";
  bool _isNewECGMeasurementVersion = true;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.ecgEveStm.listen(
        (EcgBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case ECGType.ecgChangeInts:
                _ints = event.ints!;
                break;
              case ECGType.measureComplete:
                break;
              case ECGType.date:
                _date = event.date!;
                break;
              case ECGType.cancel:
                break;
              case ECGType.fail:
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
              title: const Text("ECG"),
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
                  title: 'ECG',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(
                        child: const Text('1. setECGChangeListener()'), onPressed: () => widget.blePlugin.setECGChangeListener(EcgMeasureType.ti)),
                    Text("ints: $_ints", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("date: $_date", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('startECGMeasure'), onPressed: () => widget.blePlugin.startECGMeasure),
                    ElevatedButton(child: const Text('stopECGMeasure'), onPressed: () => widget.blePlugin.stopECGMeasure),
                    ElevatedButton(child: const Text('queryLastMeasureECGData'), onPressed: () => widget.blePlugin.queryLastMeasureECGData),
                    Text("isNewECGMeasurementVersion: $_isNewECGMeasurementVersion",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('isNewECGMeasurementVersion'),
                        onPressed: () async {
                          bool isNewECGMeasurementVersion = await widget.blePlugin.isNewECGMeasurementVersion;
                          setState(() {
                            _isNewECGMeasurementVersion = isNewECGMeasurementVersion;
                          });
                        }),
                    ElevatedButton(child: const Text('sendECGHeartRate'), onPressed: () => widget.blePlugin.sendECGHeartRate(78))
                  ])
            ]))));
  }
}
