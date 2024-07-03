import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class QuickViewPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const QuickViewPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<QuickViewPage> createState() {
    return _QuickViewPage();
  }
}

class _QuickViewPage extends State<QuickViewPage> {
  bool _quickViewState = false;
  PeriodTimeResultBean? _periodTimeResultBean;
  int _periodTimeType = -1;
  PeriodTimeBean? _periodTimeInfo;
  int _endHour = -1;
  int _endMinute = -1;
  int _startHour = -1;
  int _startMinute = -1;

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Quick View"),
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
                      title: 'queryQuickView',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        Text("quickViewState: $_quickViewState", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('queryQuickView()'),
                            onPressed: () async {
                              bool quickViewState = await widget.blePlugin.queryQuickView;
                              setState(() {
                                _quickViewState = quickViewState;
                              });
                            }),
                        ElevatedButton(child: const Text('sendQuickView(true)'), onPressed: () => widget.blePlugin.sendQuickView(true)),
                        ElevatedButton(child: const Text('sendQuickView(false)'), onPressed: () => widget.blePlugin.sendQuickView(false)),
                      ]),
                  CustomGestureDetector(
                      title: 'queryQuickView',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState2 = newDisplayState;
                        });
                      },
                      displayState: displayState2,
                      children: <Widget>[
                        Text("periodTimeType: $_periodTimeType", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("startHour: $_startHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("startMinute: $_startMinute", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("endHour: $_endHour", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        Text("endMinute: $_endMinute", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('queryQuickViewTime()'),
                            onPressed: () async {
                              _periodTimeResultBean = await widget.blePlugin.queryQuickViewTime;
                              setState(() {
                                _periodTimeType = _periodTimeResultBean!.periodTimeType;
                                _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                                _endHour = _periodTimeInfo!.endHour;
                                _endMinute = _periodTimeInfo!.endMinute;
                                _startHour = _periodTimeInfo!.startHour;
                                _startMinute = _periodTimeInfo!.startMinute;
                              });
                            }),
                        ElevatedButton(
                            child: const Text('sendQuickViewTime(CrpPeriodTimeInfo(0,0,0,0)'),
                            onPressed: () =>
                                widget.blePlugin.sendQuickViewTime(PeriodTimeBean(endHour: 0, endMinute: 0, startHour: 0, startMinute: 0))),
                      ])
                ],
              ),
            )));
  }
}
