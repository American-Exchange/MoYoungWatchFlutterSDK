import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class GoalStepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GoalStepsPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<GoalStepsPage> createState() {
    return _GoalStepPage();
  }
}

class _GoalStepPage extends State<GoalStepsPage> {
  int _goalSteps = -1;
  String _dailGoalsInfo = "";
  String _trainingDay = "";

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;
  CrossFadeState displayState4 = CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Goal Steps"),
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
                  title: 'queryGoalStep',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    Text("goalSteps: $_goalSteps", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(child: const Text('sendGoalSteps(5000)'), onPressed: () => widget.blePlugin.sendGoalSteps(5000)),
                    ElevatedButton(
                        child: const Text('queryGoalStep()'),
                        onPressed: () async {
                          int goalSteps = await widget.blePlugin.queryGoalSteps;
                          setState(() {
                            _goalSteps = goalSteps;
                          });
                        }),
                  ]),
              CustomGestureDetector(
                  title: 'queryDailyGoals',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    Text("dailyGoalsInfo: $_dailGoalsInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      child: const Text('sendDailyGoals()'),
                      onPressed: () => widget.blePlugin.sendDailyGoals(
                        DailyGoalsInfoBean(steps: 100, calories: 500, trainingTime: 30, distance: 1000),
                      ),
                    ),
                    ElevatedButton(
                        child: const Text('queryDailyGoals()'),
                        onPressed: () async {
                          DailyGoalsInfoBean dailGoalsInfo = await widget.blePlugin.queryDailyGoals;
                          setState(() {
                            _dailGoalsInfo = dailyGoalsInfoBeanToJson(dailGoalsInfo);
                          });
                        }),
                  ]),
              CustomGestureDetector(
                  title: 'queryDailyGoals',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState3 = newDisplayState;
                    });
                  },
                  displayState: displayState3,
                  children: <Widget>[
                    Text("dailyGoalsInfo: $_dailGoalsInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      child: const Text('sendTrainingDayGoals()'),
                      onPressed: () => widget.blePlugin.sendTrainingDayGoals(
                        DailyGoalsInfoBean(steps: 100, calories: 500, trainingTime: 30, distance: 10),
                      ),
                    ),
                    ElevatedButton(
                        child: const Text('queryTrainingDayGoals()'),
                        onPressed: () async {
                          DailyGoalsInfoBean dailGoalsInfo = await widget.blePlugin.queryTrainingDayGoals;
                          setState(() {
                            _dailGoalsInfo = dailyGoalsInfoBeanToJson(dailGoalsInfo);
                          });
                        }),
                    Text("trainingDay: $_trainingDay", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      child: const Text("sendTrainingDays()"),
                      onPressed: () => widget.blePlugin.sendTrainingDays(TrainingDayInfoBean(
                        enable: false,
                        trainingDays: [0, 1, 2],
                      )),
                    ),
                    ElevatedButton(
                        child: const Text('queryTrainingDay()'),
                        onPressed: () async {
                          TrainingDayInfoBean trainingDay = await widget.blePlugin.queryTrainingDay;
                          setState(() {
                            _trainingDay = trainingDayInfoBeanToJson(trainingDay);
                          });
                        })
                  ])
            ]))));
  }
}
