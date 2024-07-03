import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ClassicBluetoothAddressPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ClassicBluetoothAddressPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ClassicBluetoothAddressPage> createState() {
    return _ClassicBluetoothAddressPage();
  }
}

class _ClassicBluetoothAddressPage extends State<ClassicBluetoothAddressPage> {
  String _address = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Classic Bluetooth Address"),
              automaticallyImplyLeading: false, // 禁用默认的返回按钮
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // 手动处理返回逻辑
                },
              ),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("address: $_address"),

              ElevatedButton(
                  onPressed: () async{
                    String address = await widget.blePlugin.queryBtAddress;
                    setState(() {
                      _address = address;
                    });
                  },
                  child: const Text("queryBtAddress()")),
            ])
            )
        )
    );
  }
}
