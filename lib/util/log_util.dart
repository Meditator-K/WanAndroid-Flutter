import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'date_util.dart';

///日志工具类
class LogUtil {
  // 是否为debug模式
  static const bool _isDebug = kDebugMode;
  static const String _TAG = "XB";

  static void d(Object msg) {
    if (_isDebug) {
      _printLog('DEBUG —> ', msg);
    }
  }

  static void e(Object msg) {
    if (_isDebug) {
      _printLog('ERROR —> ', msg);
    }
  }

  static void _printLog(String level, Object msg) {
    StringBuffer sb = new StringBuffer();
    sb
      ..write(level)
      ..write(_TAG)
      ..write('[${DateUtil.dateToStr(DateTime.now())}]')
      ..write(': ')
      ..write(msg);
    //使用developer-log，不用print，因为print有长度限制，超出长度打印不完整
    log(sb.toString());
  }
}
