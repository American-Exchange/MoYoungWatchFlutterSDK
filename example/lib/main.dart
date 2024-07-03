import 'dart:async';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/utils/toast_util.dart';

import 'Global.dart';
import 'components/base/CustomGestureDetector.dart';
import 'modules/contact_list_page.dart';
import 'device.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'modules/demo.dart';

void main() {
  runApp(const MaterialApp(
    title: "moyoung ble demo",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  // final MoYoungBle _blePlugin = MoYoungBle();
  final MoYoungBle _blePlugin = Global.blePlugin;
  String _permissionTxt = "requestPermissions()";
  String _scanBtnTxt = "startScan(10*1000)";
  String _cancelScanResult = "cancelScan()";
  String _contactInfo = 'skip 2 contacts';
  bool enableBluetooth = false;
  final List<BleScanBean> _deviceList = [];
  bool isQuit = false;
  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.bleScanEveStm.listen(
        (BleScanBean event) async {
          setState(() {
            if (event.isCompleted) {
              _scanBtnTxt = "Scan completed";
            } else {
              _deviceList.add(event);
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  /// 退出app并且断开连接
  Future<bool> exitAppWithDisconnect() {
    if (!isQuit) {
      ToastUtil.show("再按一次退出app", Toast.LENGTH_SHORT);
      isQuit = true;
      return Future.value(false);
    }

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: WillPopScope(
        onWillPop: () => exitAppWithDisconnect(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomGestureDetector(
                  title: 'Permission',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState1 = newDisplayState;
                    });
                  },
                  displayState: displayState1,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const Demo(
                                // blePlugin: _blePlugin,
                                // device: device,
                                );
                          }));
                        },
                        child: const Text("Demo", style: TextStyle(fontSize: 14))),
                    ElevatedButton(child: Text(_permissionTxt, style: const TextStyle(fontSize: 14)), onPressed: requestPermissions),
                    ElevatedButton(
                        onPressed: checkBluetoothEnable,
                        child: Text("checkBluetoothPermission: $enableBluetooth", style: const TextStyle(fontSize: 14))),
                    ElevatedButton(child: Text(_contactInfo, style: const TextStyle(fontSize: 14)), onPressed: selectContact),
                  ]),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(child: Text(_scanBtnTxt, style: const TextStyle(fontSize: 14)), onPressed: startScan)),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(child: Text(_cancelScanResult, style: const TextStyle(fontSize: 14)), onPressed: cancelScan)),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            cancelScan();
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DevicePage(
                                device: _deviceList[index],
                              );
                            }));
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_deviceList[index].name, style: const TextStyle(fontSize: 16)),
                                Text(_deviceList[index].address, style: const TextStyle(height: 2, fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ));
                      // ListTile(
                      //   title: Text(_deviceList[index].name + ',' + _deviceList[index].address, style: const TextStyle(fontSize: 14)),
                      //   onTap: () {
                      //     cancelScan();
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //       return DevicePage(
                      //         device: _deviceList[index],
                      //       );
                      //     }));
                      //   });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.blue,
                      );
                    },
                    itemCount: _deviceList.length),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void checkBluetoothEnable() async {
    if (!mounted) return;
    bool _enableBluetooth = await _blePlugin.checkBluetoothEnable;
    if (!_enableBluetooth) {
      BluetoothEnable.enableBluetooth.then((value) {
        if (value == "true") {
          setState(() {
            enableBluetooth = true;
          });
        }
      });
    }
    setState(() {
      enableBluetooth = _enableBluetooth;
    });
  }

  void requestPermissions() {
    [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request().then((value) => {
          setState(() {
            Map<Permission, PermissionStatus> statuses = value;
            if (statuses[Permission.location] == PermissionStatus.denied) {
              String permissionName = Permission.location.toString();
              _permissionTxt = "$permissionName is denied";
              return;
            }
            if (statuses[Permission.storage] == PermissionStatus.denied) {
              String permissionName = Permission.storage.toString();
              _permissionTxt = "$permissionName is denied";
              return;
            }

            _permissionTxt = "Permission is granted.";
          })
        });
  }

  void startScan() {
    if (!mounted) return;
    setState(() {
      _deviceList.clear();
    });

    _blePlugin
        .startScan(10 * 1000)
        .then((value) => {
              setState(() {
                _scanBtnTxt = value ? "Scanning" : "Scan filed";
              })
            })
        .onError((error, stackTrace) => {print(error)});
  }

  Future<void> cancelScan() async {
    await _blePlugin.cancelScan;
    if (!mounted) return;
    setState(() {
      _cancelScanResult = 'cancelScan()';
    });
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlutterContactsExample(pageContext: context),
        ));

    if (!mounted) return;

    setState(() {
      String name = contact.name.toString();
      String phone = contact.phones.first.toString();
      _contactInfo = '$name, $phone';
    });
  }
}
