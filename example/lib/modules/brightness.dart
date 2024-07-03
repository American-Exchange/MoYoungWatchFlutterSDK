import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class BrightnessPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BrightnessPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BrightnessPage> createState() {
    return _BrightnessPage();
  }
}

class _BrightnessPage extends State<BrightnessPage> {
  BrightnessBean? _brightnessBean;
  int _current = -1;
  int _max = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Brightness"),
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
                  title: 'queryBrightness',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("current: $_current", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("max: $_max", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendBrightness(5), child: const Text("sendBrightness(5)")),
                    ElevatedButton(
                        onPressed: () async {
                          _brightnessBean = await widget.blePlugin.queryBrightness;
                          setState(() {
                            _current = _brightnessBean!.current;
                            _max = _brightnessBean!.max;
                          });
                        },
                        child: const Text("queryBrightness()"))
                  ])
            ]))));
  }
}
