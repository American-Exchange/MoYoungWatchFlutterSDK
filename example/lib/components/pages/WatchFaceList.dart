import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../../modules/sendWatchFace.dart';
import '../../utils/net/network_image_ssl.dart';
import '../../utils/scroll_style_util.dart';

class WatchFaceList extends StatefulWidget {
  final MoYoungBle blePlugin;
  final List testedList;
  final WatchFaceStoreTypeBean watchFaceStoreTypeBean;
  final bool isNewWatch;

  const WatchFaceList({
    required Key key,
    required this.testedList,
    required this.blePlugin,
    required this.watchFaceStoreTypeBean,
    required this.isNewWatch,
  }) : super(key: key);

  @override
  State<WatchFaceList> createState() {
    return WatchFaceListState();
  }
}

class WatchFaceListState extends State<WatchFaceList> {
  final ScrollController scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant WatchFaceList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.testedList.isNotEmpty) {
      return SizedBox(
          height: 200.0, // 指定高度
          child: ScrollConfiguration(
            behavior: EUMNoScrollBehavior(),
            child: ListView.builder(
              itemCount: widget.testedList.length,
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      height: 80,
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// 处理加载图片 忽略证书问题
                          ImageLoader(
                            imageUrl: widget.testedList[index].preview,
                            fit: BoxFit.contain,
                          ),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.testedList[index].id}", style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(const Color(0xff67E55C)),
                                    shape: MaterialStateProperty.all(BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)))),
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return SendWatchFace(
                                        watchFaceInfo: widget.testedList[index],
                                        isNewWatch: widget.isNewWatch,
                                        blePlugin: widget.blePlugin,
                                        watchFaceStoreTypeBean: widget.watchFaceStoreTypeBean);
                                  }));
                                },
                                child: const Text("发送", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ));
    } else {
      return Container();
    }
  }
}
