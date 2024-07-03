import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';

class TrainingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TrainingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TrainingPage> createState() {
    return _TrainingPage();
  }
}

class _TrainingPage extends State<TrainingPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<HistoryTrainList> _historyTrainList = [];
  int _type = -1;
  List<TrainingInfo> _trainingList = [];
  CrossFadeState displayState1 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
    setTrainingStateEveStm();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.trainingEveStm.listen(
        (TrainBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case TrainType.historyTrainingChange:
                _historyTrainList = event.historyTrainList!;
                break;
              case TrainType.trainingChange:
                _trainingList = event.trainingList!;
                break;
              default:
                break;
            }
          });
        },
      ),
    );
  }

  void setTrainingStateEveStm() {
    _streamSubscriptions.add(
      widget.blePlugin.trainingStateEveStm.listen(
        (int event) {
          if (!mounted) return;
          setState(() {
            _type = event;
          });
        },
      ),
    );
  }

  // void deleteTrainingStateEveStm() {
  //   if (_streamSubscriptions.contains(a)) {
  //     _streamSubscriptions.remove(a);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Training"),
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
            children: <Widget>[
              CustomGestureDetector(
                  title: 'Training',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => {widget.blePlugin.startTraining(0)},
                      child: const Text("startTraining(WALK)"),
                    ),
                    ElevatedButton(
                      onPressed: () => {widget.blePlugin.startTraining(1)},
                      child: const Text("startTraining(RUN)"),
                    ),
                    Text("type: $_type", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingComplete),
                        child: const Text("setTrainingState(trainingComplete)")),

                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingPause),
                        child: const Text("setTrainingState(trainingPause)")),
                    ElevatedButton(
                        onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingContinue),
                        child: const Text("setTrainingState(trainingContinue)")),
                    Text("historyTrainList: ${_historyTrainList.map((e) => e.toJson())}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      onPressed: () => {
                        // deleteTrainingStateEveStm(),
                        widget.blePlugin.queryHistoryTraining,
                      },
                      child: const Text("queryHistoryTraining()"),
                    ),  Text("trainingList: ${_trainingList.map((e) => e.toJson())}",
                        style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                      onPressed: () => {
                        // deleteTrainingStateEveStm(),
                        if (_historyTrainList.isNotEmpty) {widget.blePlugin.queryTraining(_historyTrainList[0].id!)},
                      },
                      child: const Text("queryTraining()"),
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
