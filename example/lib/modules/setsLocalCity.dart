import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class SetsLocalCityPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SetsLocalCityPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<SetsLocalCityPage> createState() {
    return _SetsLocalCityPage();
  }
}

class _SetsLocalCityPage extends State<SetsLocalCityPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Sets Local City"),
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
                  title: 'City',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(onPressed: () => widget.blePlugin.sendLocalCity("长沙"), child: const Text("sendLocalCity(长沙)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendLocalCity("深圳"), child: const Text("sendLocalCity(深圳)")),
                  ])
            ]))));
  }
}
