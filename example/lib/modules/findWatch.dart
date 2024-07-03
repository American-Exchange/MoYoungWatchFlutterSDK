import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class FindWatchPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindWatchPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<FindWatchPage> createState() {
    return _FindWatchPage();
  }
}

class _FindWatchPage extends State<FindWatchPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Watch"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(
                child: ListView(children: [
              CustomGestureDetector(
                  title: 'Find Watch',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[ElevatedButton(child: const Text('findDevice()'), onPressed: () => widget.blePlugin.findDevice)])
            ]))));
  }
}
