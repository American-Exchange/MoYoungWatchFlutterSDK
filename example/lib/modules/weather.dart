import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class WeatherPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const WeatherPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() {
    return _WeatherPage();
  }
}

class _WeatherPage extends State<WeatherPage> {
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Weather"),
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
                      title: 'Send  weather',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        const Text(
                            "The watch actively listens to the updateWeather type callback through contactAvatarEveStm, indicating that the weather needs to be updated.",
                            style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                        ElevatedButton(
                            child: const Text('sendTodayWeather()'),
                            onPressed: () => widget.blePlugin.sendTodayWeather(
                                TodayWeatherBean(city: "changsha", lunar: "晴", festival: "儿童节", pm25: 111, temp: 20, weatherId: 5))),
                        ElevatedButton(
                            child: const Text('sendFutureWeather()'), onPressed: () => widget.blePlugin.sendFutureWeather(getFutureWeathers())),
                      ])
                ],
              ),
            )));
  }

  FutureWeatherListBean getFutureWeathers() {
    FutureWeatherBean futureWeatherBean1 = FutureWeatherBean(weatherId: 5, lowTemperature: 10, highTemperature: 30);
    FutureWeatherBean futureWeatherBean2 = FutureWeatherBean(weatherId: 6, lowTemperature: 11, highTemperature: 40);

    List<FutureWeatherBean> futureList = [];
    futureList.add(futureWeatherBean1);
    futureList.add(futureWeatherBean2);

    return FutureWeatherListBean(future: futureList);
  }
}
