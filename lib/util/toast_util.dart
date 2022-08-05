import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ToastUtil {
  static void showToast(String msg) {
    SmartDialog.showToast(msg, alignment: Alignment.center);
  }
}
