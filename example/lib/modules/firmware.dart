import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

import '../components/base/CustomGestureDetector.dart';
import '../utils/toast_util.dart';

class FirmwarePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  final BleScanBean device;

  const FirmwarePage({Key? key, required this.blePlugin, required this.device}) : super(key: key);

  @override
  State<FirmwarePage> createState() {
    return _FirmwarePage();
  }
}

class _FirmwarePage extends State<FirmwarePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _firmwareVersion = "queryFirmwareVersion()";
  String _newFirmwareInfo = "checkFirmwareVersion()";
  UpgradeErrorBean? _upgradeError;
  int _error = -1;
  String _errorContent = "";
  int _upgradeProgress = -1;
  String _hsOtaAddress = "";
  int _deviceOtaStatus = -1;
  String _uuid = "";
  String upgradeFilePath = "";
  String pathname = "https://p.moyoung.com/uploads/jieli/V37_QIpBxMKILvdR5SYRGAhsUVx3CTAxdIxV/fZaBQ5zVwUMPiM4mxHBWBEGe6XzeC5P6.ufw";
  String platformText = "";

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
    switch (widget.device.platform) {
      case 0:
        platformText = "default";
        break;
      case 1:
        platformText = "Nordic";
        break;
      case 2:
        platformText = "Hs";
        break;
      case 3:
        platformText = "Realtek";
        break;
      case 4:
        platformText = "Goodix";
        break;
      case 5:
        platformText = "Sifli";
        break;
      case 6:
        platformText = "Jieli";
        break;
    }
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.oTAEveStm.listen(
        (OTABean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case OTAProgressType.downloadStart:
                break;
              case OTAProgressType.downloadComplete:
                break;
              case OTAProgressType.progressStart:
                break;
              case OTAProgressType.progressChanged:
                _upgradeProgress = event.upgradeProgress!;
                break;
              case OTAProgressType.upgradeCompleted:
                _upgradeProgress = 100;
                break;
              case OTAProgressType.upgradeAborted:
                break;
              case OTAProgressType.error:
                _upgradeError = event.upgradeError!;
                _error = _upgradeError!.error!;
                _errorContent = _upgradeError!.errorContent!;
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
          title: const Text("Firmware"),
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
          Padding(
              padding: const EdgeInsets.all(10.0), // 内边距，可以根据需要调整
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("current platform: " + platformText, style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                  Text("upgradeProgress: $_upgradeProgress", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  Text("error: $_error", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                  Text("errorContent: $_errorContent", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ],
              )),
          CustomGestureDetector(
              title: 'HS OTA',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState1 = newDisplayState;
                });
              },
              displayState: displayState1,
              children: <Widget>[
                Text("_firmwareVersion: $_firmwareVersion", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(child: const Text("1.queryFirmwareVersion"), onPressed: queryFirmwareVersion),
                Text("_newFirmwareInfo: $_newFirmwareInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text("2.checkFirmwareVersion"), onPressed: () => checkFirmwareVersion(_firmwareVersion, OTAType.normalUpgradeType)),
                Text("hsOtaAddress: $_hsOtaAddress", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text('3.queryHsOtaAddress()'),
                    onPressed: () async {
                      String hsOtaAddress = await widget.blePlugin.queryHsOtaAddress;
                      setState(() {
                        _hsOtaAddress = hsOtaAddress;
                      });
                    }),
                ElevatedButton(child: const Text('4.enableHsOta()'), onPressed: () => widget.blePlugin.enableHsOta),
                ElevatedButton(child: const Text('5.startOTA(hsOtaAddress)'), onPressed: () => startOTA(_hsOtaAddress)),
                ElevatedButton(child: const Text('6.abortOTA(oTAType)'), onPressed: () => widget.blePlugin.abortOTA(widget.device.platform)),
              ]),
          CustomGestureDetector(
              title: 'Realtek/Sifli/Jieli OTA',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState2 = newDisplayState;
                });
              },
              displayState: displayState2,
              children: <Widget>[
                Text("_firmwareVersion: $_firmwareVersion", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(child: const Text("1.queryFirmwareVersion"), onPressed: queryFirmwareVersion),
                Text("_newFirmwareInfo: $_newFirmwareInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text("2.checkFirmwareVersion"), onPressed: () => checkFirmwareVersion(_firmwareVersion, OTAType.normalUpgradeType)),
                ElevatedButton(child: const Text('3.startOTA(address)'), onPressed: () => startOTA(widget.device.address)),
                ElevatedButton(child: const Text('4.abortOTA(oTAType)'), onPressed: () => widget.blePlugin.abortOTA(widget.device.platform)),
              ]),
          CustomGestureDetector(
              title: 'Nordic/Goodix OTA',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState3 = newDisplayState;
                });
              },
              displayState: displayState3,
              children: <Widget>[
                Text("_firmwareVersion: $_firmwareVersion", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(child: const Text("1.queryFirmwareVersion"), onPressed: queryFirmwareVersion),
                Text("_newFirmwareInfo: $_newFirmwareInfo", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text("2.checkFirmwareVersion"), onPressed: () => checkFirmwareVersion(_firmwareVersion, OTAType.normalUpgradeType)),
                ElevatedButton(child: const Text('3.startOTA(address)'), onPressed: () => startOTA(widget.device.address)),
                ElevatedButton(child: const Text('4.abortOTA(oTAType)'), onPressed: () => widget.blePlugin.abortOTA(widget.device.platform)),
                Text("deviceOtaStatus: $_deviceOtaStatus", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                ElevatedButton(
                    child: const Text('queryDeviceOtaStatus()'),
                    onPressed: () async {
                      int deviceOtaStatus = await widget.blePlugin.queryDeviceOtaStatus;
                      setState(() {
                        _deviceOtaStatus = deviceOtaStatus;
                      });
                    }),
              ]),
        ])),
      ),
    );
  }

  Future<void> queryFirmwareVersion() async {
    String firmwareVersion = await widget.blePlugin.queryFirmwareVersion;
    if (!mounted) {
      return;
    }
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  Future<void> checkFirmwareVersion(String version, int oTAType) async {
    CheckFirmwareVersionBean versionInfo = await widget.blePlugin.checkFirmwareVersion(FirmwareVersion(version: version, otaType: oTAType));
    if (!mounted) {
      return;
    }
    setState(() {
      _newFirmwareInfo = checkFirmwareVersionBeanToJson(versionInfo);
    });
  }

  Future<void> startOTA(String address) async {
    if (checkFirmwareVersionBeanFromJson(_newFirmwareInfo).isLatestVersion!) ToastUtil.show("固件已为最新版，请联系项目配置版本", Toast.LENGTH_SHORT);
    widget.blePlugin.startOTA(OtaBean(address: address, type: widget.device.platform));
  }

  ///获取下载路径
  Future<String> getPathFile(String file) async {
    int index = file.lastIndexOf('/');
    String name = file.substring(index, file.length);
    String pathFile = "";
    await getApplicationDocumentsDirectory().then((value) => pathFile = value.path + name);
    return pathFile;
  }

  ///下载文件
  Future<void> downloadFile(String file) async {
    String pathFile = await getPathFile(file);
    BaseOptions options = BaseOptions(
      baseUrl: file,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    await dio
        .download(file, pathFile, onReceiveProgress: (received, total) {})
        .then((value) => {widget.blePlugin.startOTA(OtaBean(address: pathFile, type: OTAMcuType.startJieliOta))})
        .onError((error, stackTrace) => {});
  }
}
