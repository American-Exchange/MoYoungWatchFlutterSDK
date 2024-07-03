import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class TemperatureSystemPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TemperatureSystemPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TemperatureSystemPage> createState() {
    return _TemperatureSystemPage();
  }
}

class _TemperatureSystemPage extends State<TemperatureSystemPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _tempUnit = -1;
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.weatherChangeEveStm.listen(
        (WeatherChangeBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case WeatherChangeType.updateWeather:
                break;
              case WeatherChangeType.tempUnitChange:
                _tempUnit = event.tempUnit!;
                break;
              default:
                break;
            }
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
              title: const Text("Temperature System"),
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
                    Text("weather: $_tempUnit", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendTempUnit(TempUnit.celsius), child: const Text("sendTempUnit()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.sendTempUnit(TempUnit.fahrenheit), child: const Text("sendTempUnit()")),
                    ElevatedButton(onPressed: () => widget.blePlugin.queryTempUnit, child: const Text("queryTempUnit()"))
                  ])
            ]))));
  }
}
