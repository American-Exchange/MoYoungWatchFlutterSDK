import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class ElectronicCardPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ElectronicCardPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ElectronicCardPage();
  }
}

class _ElectronicCardPage extends State<ElectronicCardPage> {
  String _electronicCardCountInfo = "";
  String _electronicCardInfo = "";
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ElectronicCard"),
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
                title: 'Electronic Card',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  Text("electronicCardCountInfo: $_electronicCardCountInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                 ElevatedButton(
                      onPressed: () async {
                        ElectronicCardCountInfoBean electronicCardCountInfo = await widget.blePlugin.queryElectronicCardCount;
                        setState(() {
                          _electronicCardCountInfo = electronicCardCountInfoBeanToJson(electronicCardCountInfo);
                        });
                      },
                      child: const Text("queryElectronicCardCount")),
                  Text("electronicCardInfo: $_electronicCardInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  ElevatedButton(
                      onPressed: () async {
                        ElectronicCardInfoBean electronicCardInfo = await widget.blePlugin.queryElectronicCard(2);
                        setState(() {
                          _electronicCardInfo = electronicCardInfoBeanToJson(electronicCardInfo);
                        });
                      },
                      child: const Text("queryElectronicCard")),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.sendElectronicCard(ElectronicCardInfoBean(
                          id: 2,
                          title: "百度",
                          url: "https://www.baidu.com/",
                        ));
                      },
                      child: const Text("sendElectronicCard")),
                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.deleteElectronicCard(2);
                      },
                      child: const Text("deleteElectronicCard")),

                  ElevatedButton(
                      onPressed: () async {
                        widget.blePlugin.sendElectronicCardList([2]);
                      },
                      child: const Text("sendElectronicCardList-sort"))
                ])
          ]),
        ),
      ),
    );
  }
}
