import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class UserInfoPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const UserInfoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<UserInfoPage> createState() {
    return _UserInfoPage();
  }
}

class _UserInfoPage extends State<UserInfoPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("UserInfo"),
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
                      title: 'Send UserInfo',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        ElevatedButton(
                            child: const Text('sendUserInfo()-MALE'),
                            onPressed: () => widget.blePlugin.sendUserInfo(UserBean(weight: 50, height: 180, gender: UserBean.male, age: 30))),
                        ElevatedButton(
                            child: const Text('sendUserInfo()-FEMALE'),
                            onPressed: () => widget.blePlugin.sendUserInfo(UserBean(weight: 50, height: 170, gender: UserBean.female, age: 31))),
                        ElevatedButton(child: const Text('sendStepLength(5)'), onPressed: () => widget.blePlugin.sendStepLength(5)),
                      ])
                ],
              ),
            )));
  }
}
