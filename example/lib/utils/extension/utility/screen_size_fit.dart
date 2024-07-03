import 'package:flutter/material.dart';

class ScreenSizeFit {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? rpx;
  static double? px;
  static double? vh;

  static void initialize(BuildContext context, {double standardWidth = 720, double standardHeight = 1520}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    rpx = screenWidth! / standardWidth;
    px = screenWidth! / standardWidth * 2;
    vh = screenHeight! / standardHeight;
  }

  // 按照像素来设置
  static double setPx(double size) {
    return ScreenSizeFit.rpx! * size * 2;
  }

  // 按照rxp来设置
  static double setRpx(double size) {
    return ScreenSizeFit.rpx! * size;
  }

  // 根据vh来设置
  static double setVh(double size) {
    return ScreenSizeFit.vh! * size;
  }

  // 根据手机屏幕宽度获取几倍图
  static double getMultiplesImages() {
    return screenWidth!;
  }
}