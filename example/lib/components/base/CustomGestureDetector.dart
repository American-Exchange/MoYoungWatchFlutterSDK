import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin_example/components/widget/shadow_box.dart';

import '../../utils/data/toggle_panel.dart';
import '../widget/functional_item_title.dart';

class CustomGestureDetector extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final ValueChanged<CrossFadeState> childrenBCallBack;
  final CrossFadeState displayState;

  const CustomGestureDetector({Key? key, required this.children, required this.title, required this.childrenBCallBack, required this.displayState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              SizedBox(
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    childrenBCallBack(TogglePanel.togglePanel(displayState));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: FunctionalItemTitle(title: title),
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstCurve: Curves.easeInCirc,
                secondCurve: Curves.easeInToLinear,
                firstChild: Container(),
                secondChild: Padding(
                    padding: const EdgeInsets.all(10.0), // 内边距，可以根据需要调整
                    child: Align(
                        alignment: Alignment.bottomLeft, // 或者Alignment.centerLeft
                        child:
                            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: children))),
                duration: const Duration(milliseconds: 300),
                crossFadeState: displayState,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
