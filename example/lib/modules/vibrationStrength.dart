import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class VibrationStrengthPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const VibrationStrengthPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<VibrationStrengthPage> createState() {
    return _VibrationStrengthPage();
  }
}

class _VibrationStrengthPage extends State<VibrationStrengthPage> {
  VibrationStrength value = VibrationStrength(value: 1);
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("VibrationStrength"),
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
                      title: 'queryVibrationStrength',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                          ElevatedButton(
                            child: const Text('sendVibrationStrength(low)'),
                            onPressed: () => widget.blePlugin.sendVibrationStrength(VibrationStrengthType.low)),
                        ElevatedButton(
                            child: const Text('sendVibrationStrength(medium)'),
                            onPressed: () => widget.blePlugin.sendVibrationStrength(VibrationStrengthType.medium)),
                        ElevatedButton(
                            child: const Text('sendVibrationStrength(strong)'),
                            onPressed: () => widget.blePlugin.sendVibrationStrength(VibrationStrengthType.strong)),
                        Text("vibration strength: ${vibrationStrengthToJson(value)}",
                            style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('queryVibrationStrength()'),
                            onPressed: () async => {value = await widget.blePlugin.queryVibrationStrength})
                      ])
                ],
              ),
            )));
  }
}
