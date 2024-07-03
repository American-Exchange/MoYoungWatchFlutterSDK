import 'package:moyoung_ble_plugin_example/utils/extension/utility/screen_size_fit.dart';

extension DoubleFit on double {
  double get px {
    return ScreenSizeFit.setPx(this);
  }

  double get rpx {
    return ScreenSizeFit.setRpx(this);
  }

  double get vh {
    return ScreenSizeFit.setVh(this);
  }
}