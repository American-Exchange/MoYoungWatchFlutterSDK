import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class UnitSystemPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const UnitSystemPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<UnitSystemPage> createState() {
    return _UnitSystemPage();
  }
}

class _UnitSystemPage extends State<UnitSystemPage> {
  int _unitSystemType = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("UnitSystem"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(
                child: ListView(
              children: [
                CustomGestureDetector(
                    title: 'Unit System',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState1 = newDisplayState;
                      });
                    },
                    displayState: displayState1,
                    children: <Widget>[
                      Text("unitSystemType: $_unitSystemType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                      ElevatedButton(
                          child: const Text('queryMetricSystem()'),
                          onPressed: () async {
                            int unitSystemType = await widget.blePlugin.queryUnitSystem;
                            setState(() {
                              _unitSystemType = unitSystemType;
                            });
                          }),
                      ElevatedButton(
                          child: const Text('sendMetricSystem(METRIC_SYSTEM)'),
                          onPressed: () => widget.blePlugin.sendUnitSystem(UnitSystemType.metricSystem)),
                      ElevatedButton(
                          child: const Text('sendMetricSystem(IMPERIAL_SYSTEM)'),
                          onPressed: () => widget.blePlugin.sendUnitSystem(UnitSystemType.imperialSystem)),
                    ])
              ],
            ))));
  }
}
