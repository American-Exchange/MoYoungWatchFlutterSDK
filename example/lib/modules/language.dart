import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class LanguagePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const LanguagePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<LanguagePage> createState() {
    return _LanguagePage();
  }
}

class _LanguagePage extends State<LanguagePage> {
  DeviceLanguageBean? _deviceLanguageBean;
  List<int> _languageType = [];
  int _type = -1;

  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Language"),
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
                  title: 'Device Language',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("type: $_type", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('sendDeviceLanguage()'),
                        onPressed: () => widget.blePlugin.sendDeviceLanguage(DeviceLanguageType.languageChinese)),
                    ElevatedButton(
                        child: const Text('queryDeviceVersion()'),
                        onPressed: () async {
                          int type = await widget.blePlugin.queryDeviceVersion;
                          setState(() {
                            _type = type;
                          });
                        }),
                    Text("languageType: $_languageType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        child: const Text('queryDeviceLanguage()'),
                        onPressed: () async {
                          _deviceLanguageBean = await widget.blePlugin.queryDeviceLanguage;
                          setState(() {
                            _languageType = _deviceLanguageBean!.languageType;
                            _type = _deviceLanguageBean!.type;
                          });
                        })
                  ])
            ]))));
  }
}
