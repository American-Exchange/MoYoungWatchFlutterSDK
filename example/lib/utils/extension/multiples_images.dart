import 'package:moyoung_ble_plugin_example/utils/extension/utility/screen_size_fit.dart';

class MultiplesImages {
  static double? screenWidth;

  static int getMultiplesImages() {
    screenWidth = ScreenSizeFit.getMultiplesImages();
    if (screenWidth! <= 750) {
      return 1;
    } else if (screenWidth! <= 1000) {
      return 2;
    } else {
      return 3;
    }
  }
}