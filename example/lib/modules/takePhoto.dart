import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class TakePhotoPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TakePhotoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TakePhotoPage> createState() {
    return _TakePhotoPage();
  }
}

class _TakePhotoPage extends State<TakePhotoPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _camera = "";
  int _delayTime = -1;
  int _phone = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.cameraEveStm.listen(
        (CameraBean event) {
          if (!mounted) return;
          setState(() {
            _camera = event.takePhoto!;
            _delayTime = event.delayTime!;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      widget.blePlugin.phoneEveStm.listen(
        (int event) {
          if (!mounted) return;
          setState(() {
            _phone = event;
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
              title: const Text("Take Photo"),
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
                  title: 'Supported Contacts',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("camera: $_camera", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("delayTime: $_delayTime", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('enterCameraView'), onPressed: () => widget.blePlugin.enterCameraView),
                    ElevatedButton(child: const Text('exitCameraView'), onPressed: () => widget.blePlugin.exitCameraView),
                    const Text("Hanging up a call on the watch will return the hang-up type through this callback",
                        style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    Text("phone: $_phone", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey))
                  ])
            ]))));
  }
}
