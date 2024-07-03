import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class GSensorPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GSensorPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GSensorPage();
  }
}

class _GSensorPage extends State<GSensorPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GSensor"),
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
                title: 'sendGsensorCalibration',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  ElevatedButton(onPressed: () => widget.blePlugin.sendGsensorCalibration, child: const Text("sendGsensorCalibration"))
                ])
          ]),
        ),
      ),
    );
  }
}
