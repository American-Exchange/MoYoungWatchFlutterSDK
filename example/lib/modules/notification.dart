import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotificationPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotificationPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<NotificationPage> createState() {
    return _NotificationPage();
  }
}

class _NotificationPage extends State<NotificationPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List _list = [];
  bool _state = false;
  String _number = "";
  List<int> _messageType = [];

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.callNumberEveStm.listen((String event) {
        setState(() {
          _number = event;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Notification"),
            ),
            body: Center(
                child: ListView(children: [
              Text("list: $_list"),
              Text("state: $_state"),
              Text("number: $_number"),
              Text("messageType: $_messageType"),
              ElevatedButton(
                  child: const Text('android:sendOtherMessageState'),
                  onPressed: () =>
                      widget.blePlugin.sendOtherMessageState(true)),
              ElevatedButton(
                  child: const Text("android:queryOtherMessageState"),
                  onPressed: () async {
                    bool state = await widget.blePlugin.queryOtherMessageState;
                    setState(() {
                      _state = state;
                    });
                  }),
              ElevatedButton(
                  child: const Text('sendMessage(MessageInfo()'),
                  onPressed: () => widget.blePlugin.sendMessage(MessageBean(
                      message: 'message',
                      type: BleMessageType.messagePhone,
                      versionCode: 229,
                      isHs: true,
                      isSmallScreen: true))),
              ElevatedButton(
                  child: const Text('android:endCall()'),
                  onPressed: () => widget.blePlugin.endCall),
              ElevatedButton(
                  child: const Text('android:sendCallContactName()'),
                  onPressed: () => widget.blePlugin.sendCallContactName("嘿嘿")),
              ElevatedButton(
                  child: const Text('android:queryMessageList()'),
                  onPressed: () async {
                    List<int> messageType = await widget.blePlugin.queryMessageList;
                    setState(() {
                      _messageType = messageType;
                    });
                  }),
              ElevatedButton(
                  child: const Text('ios:setNotification()'),
                  onPressed: () => widget.blePlugin.setNotification([
                        NotificationType.facebook,
                        NotificationType.gmail,
                        NotificationType.kakao
                      ])),
              ElevatedButton(
                  child: const Text('ios:getNotification'),
                  onPressed: () async {
                    List list = await widget.blePlugin.getNotification;
                    setState(() {
                      _list = list;
                    });
                  }),
            ]))));
  }
}
