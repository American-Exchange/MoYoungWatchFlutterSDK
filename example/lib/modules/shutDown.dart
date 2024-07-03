import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class ShutDownPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ShutDownPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ShutDownPage> createState() {
    return _ShutDownPage();
  }
}

class _ShutDownPage extends State<ShutDownPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Shut Down"),
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
                  title: 'Shut Down',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(child: const Text('shutDown()'), onPressed: () => widget.blePlugin.shutDown),
                    ElevatedButton(child: const Text('reset()'), onPressed: () => widget.blePlugin.reset)
                  ])
            ]))));
  }
}
