import 'package:flutter/material.dart';

///路由跳转
class NavigatorUtil {
  ///打开指定页面，将其他页面全部移除，参数为指定页面对象
  static pushAndRemoveUntil(context, page) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => page),
        (route) => false);
  }

  ///添加，将需要进入的页面push到栈顶，其参数是对应的路由对象，可通过构造方法传递参数
  static push(context, page, {bool opaque: true}) {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: opaque,
            pageBuilder: (context, animation, secondaryAnimation) => page));
  }

  ///替换，将当前页面替换为传入的页面，其参数是对应的路由对象，可通过构造方法传递参数
  static pushReplace(context, page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }
}
