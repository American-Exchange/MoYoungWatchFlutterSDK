import 'package:flutter/cupertino.dart';
import 'package:moyoung_ble_plugin/impl/moyoung_contants.dart';

class TogglePanel {
  static final List _displayStatusList = List<CrossFadeState>.filled(4, CrossFadeState.showFirst);

  static CrossFadeState togglePanel(CrossFadeState displayState) {
    if (displayState == CrossFadeState.showFirst) {
      return CrossFadeState.showSecond;
    } else {
      return CrossFadeState.showFirst;
    }
  }
}
