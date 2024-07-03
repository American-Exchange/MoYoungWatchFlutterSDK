import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class MusicPlayerPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const MusicPlayerPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MusicPlayerPage> createState() {
    return _MusicPlayerPage();
  }
}

class _MusicPlayerPage extends State<MusicPlayerPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int phoneOperationType = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.phoneEveStm.listen(
        (dynamic event) {
          if (!mounted) return;
          setState(() {
            phoneOperationType = event;
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
              title: const Text("Music Player"),
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
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Watch controls phone callback:", style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                      Text("phoneOperationType: $phoneOperationType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey))
                    ],
                  )),
              CustomGestureDetector(
                  title: 'Phone controls Watch',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setPlayerState(PlayerStateType.musicPlayerPause),
                        child: const Text("setPlayerState(musicPlayerPause)")),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setPlayerState(PlayerStateType.musicPlayerPlay),
                        child: const Text("setPlayerState(musicPlayerPlay)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendSongTitle("111"), child: const Text("sendSongTitle()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendLyrics("lyrics"), child: const Text("sendLyrics()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.closePlayerControl, child: const Text("closePlayerControl()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendCurrentVolume(50), child: const Text("sendCurrentVolume(50)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendMaxVolume(100), child: const Text("sendMaxVolume(100)"))
                  ])
            ]))));
  }
}
