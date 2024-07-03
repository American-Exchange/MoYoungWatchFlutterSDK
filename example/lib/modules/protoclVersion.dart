import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class ProtocolVersionPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ProtocolVersionPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ProtocolVersionPage> createState() {
    return _ProtocolVersionPage();
  }
}

class _ProtocolVersionPage extends State<ProtocolVersionPage> {
  String _protocolVersion = "";
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Protocol Version"),
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
                  title: 'Protocol Version',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("protocolVersion: $_protocolVersion", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          String protocolVersion = await widget.blePlugin.getProtocolVersion;
                          setState(() {
                            _protocolVersion = protocolVersion;
                          });
                        },
                        child: const Text("getProtocolVersion()"))
                  ])
            ]))));
  }
}
