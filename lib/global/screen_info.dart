import 'package:flutter/material.dart';

///屏幕尺寸
class ScreenInfo {
  static ScreenInfo? _instance;

  factory ScreenInfo() => _getInstance();

  ScreenInfo._internal();

  static ScreenInfo _getInstance() {
    if (_instance == null) {
      _instance = ScreenInfo._internal();
    }
    return _instance!;
  }

  late double screenWidth;

  late double screenHeight;

  late double top;

  late double bottom;

  void setScreenData(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    top = MediaQuery.of(context).padding.top;
    bottom = MediaQuery.of(context).padding.bottom;
  }
}
