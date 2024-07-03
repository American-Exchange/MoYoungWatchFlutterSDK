import 'package:moyoung_ble_plugin_example/utils/extension/utility/screen_size_fit.dart';

extension IntFit on int {
  double get px {
    return ScreenSizeFit.setPx(toDouble());
  }

  double get rpx {
    return ScreenSizeFit.setRpx(toDouble());
  }

  double get vh {
    return ScreenSizeFit.setVh(toDouble());
  }
}