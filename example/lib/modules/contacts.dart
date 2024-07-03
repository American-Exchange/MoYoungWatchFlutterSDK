import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../components/base/CustomGestureDetector.dart';
import '../utils/imgCompress.dart';
import '../utils/toast_util.dart';
import 'contact_list_page.dart';

class ContactsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ContactsPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ContactsPage> createState() {
    return _ContactsPage();
  }
}

class _ContactsPage extends State<ContactsPage> {
  ContactConfigBean? _contactConfigBean;
  String _contactStr = 'sendContact()';
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _progress = -1;
  int _error = -1;
  int _savedSuccess = -1;
  int _savedFail = -1;
  int _contactCount = -1;
  bool _supported = false;
  int _count = -1;
  int _width = -1;
  int _height = -1;
  bool _isSupport = false;

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;
  CrossFadeState displayState4 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.contactAvatarEveStm.listen(
        (FileTransBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case TransType.transStart:
                break;
              case TransType.transChanged:
                _progress = event.progress!;
                break;
              case TransType.transCompleted:
                _progress = event.progress!;
                break;
              case TransType.error:
                _error = event.error!;
                break;
              default:
                break;
            }
          });
        },
      ),
    );

    _streamSubscriptions.add(
      widget.blePlugin.contactEveStm.listen(
        (ContactListenBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case ContactListenType.savedSuccess:
                _savedSuccess = event.savedSuccess!;
                break;
              case ContactListenType.savedFail:
                _savedFail = event.savedFail!;
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
              title: const Text("Contacts"),
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
                    Text("supported: $_supported", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("count: $_count", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("width: $_width", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("height: $_height", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          _contactConfigBean = await widget.blePlugin.checkSupportQuickContact;
                          setState(() {
                            _supported = _contactConfigBean!.supported;
                            _count = _contactConfigBean!.count;
                            _width = _contactConfigBean!.width;
                            _height = _contactConfigBean!.height;
                          });
                        },
                        child: const Text("checkSupportQuickContact()", style: TextStyle(fontSize: 14))),
                    Text("contactCount: $_contactCount", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          int contactCount = await widget.blePlugin.queryContactCount;
                          setState(() {
                            _contactCount = contactCount;
                          });
                        },
                        child: const Text("queryContactCount()", style: TextStyle(fontSize: 14))),
                    Text("isSupport: $_isSupport", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () async {
                          bool isSupport = await widget.blePlugin.queryContactNumberSymbol;
                          setState(() {
                            _isSupport = isSupport;
                          });
                        },
                        child: const Text("queryContactNumberSymbol()", style: TextStyle(fontSize: 14))),
                  ]),
              CustomGestureDetector(
                  title: 'send Contacts',
                  childrenBCallBack: (CrossFadeState newDisplayState) {
                    setState(() {
                      displayState2 = newDisplayState;
                    });
                  },
                  displayState: displayState2,
                  children: <Widget>[
                    Text("savedSuccess: $_savedSuccess", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("savedFail: $_savedFail", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () {
                          if (_contactConfigBean != null) {
                            selectContact();
                          }
                        },
                        child: Text(_contactStr, style: const TextStyle(fontSize: 14))),
                    const Text("Node:First please click checkSupportQuickContact,if _width and _height are 0, unable to sendContactAvatar.",
                        style: TextStyle(height: 1.5, fontSize: 14, color: Colors.deepOrange)),
                    Text("progress: $_progress", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    Text("error: $_error", style: const TextStyle(height: 1.5, fontSize: 14, color: Colors.grey)),
                    ElevatedButton(
                        onPressed: () {
                          if (_contactConfigBean != null) {
                            sendContactAvatar();
                          }
                        },
                        child: const Text("sendContactAvatar", style: TextStyle(fontSize: 14))),
                    ElevatedButton(onPressed: () => widget.blePlugin.deleteContact(0), child: const Text("deleteContact(0)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.deleteContactAvatar(0), child: const Text("deleteContactAvatar(0)")),
                    ElevatedButton(onPressed: () => widget.blePlugin.clearContact(), child: const Text("clearContact()")),
                  ])
            ]))));
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlutterContactsExample(pageContext: context),
        ));
    // if (int.parse(contact.id) < _contactConfigBean!.count) {
    print('-----${contact.phones.first}');
    widget.blePlugin.sendContact(ContactBean(
      id: _contactCount + 1,
      width: _contactConfigBean!.width,
      height: _contactConfigBean!.height,
      address: _contactCount + 1,
      name: contact.name.first,
      number: contact.phones.first.number,
      avatar: contact.thumbnail,
      timeout: 30,
    ));

    if (!mounted) {
      return;
    }

    setState(() {
      String name = contact.name.first;
      String number = contact.phones.first.number;
      _contactStr = '$name, $number';
    });
    // }
  }

  Future<void> sendContactAvatar() async {
    try {
      final Contact contact = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlutterContactsExample(pageContext: context),
          ));

      if (contact.thumbnail == null) return;
      Uint8List? img;
      img = await compressImage(contact.thumbnail!);
      if (!await getImageDimensions(img, _width, _height)) ToastUtil.show("图片宽高不一致，请更换联系人头像", Toast.LENGTH_SHORT);
      widget.blePlugin.sendContactAvatar(ContactBean(
        id: _contactCount + 1,
        width: _width,
        height: _height,
        address: _contactCount + 1,
        name: contact.name.first,
        number: contact.phones.first.number,
        avatar: img,
        timeout: 30,
      ));
    } catch (e) {
      ToastUtil.show("联系人信息异常，请仔细核对：$e", Toast.LENGTH_SHORT);
    }
  }
}
