import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BreathingLightPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BreathingLightPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BreathingLightPage> createState() {
    return _BreathingLightPage();
  }
}

class _BreathingLightPage extends State<BreathingLightPage> {
  bool _breathingLight = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Breathing Light"),
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
                  title: 'Breathing Light',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("breathingLight: $_breathingLight", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('sendBreathingLight(false)'), onPressed: () => widget.blePlugin.sendBreathingLight(false)),
                    ElevatedButton(child: const Text('sendBreathingLight(true)'), onPressed: () => widget.blePlugin.sendBreathingLight(true)),
                    ElevatedButton(
                        child: const Text('queryBreathingLight()'),
                        onPressed: () async {
                          bool breathingLight = await widget.blePlugin.queryBreathingLight;
                          setState(() {
                            _breathingLight = breathingLight;
                          });
                        })
                  ])
            ]))));
  }
}
