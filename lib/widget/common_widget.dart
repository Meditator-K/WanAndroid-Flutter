import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///通用的appbar
PreferredSize commonAppbar(text,
    {double elevation: 1,
    backgroundColor: Colors.green,
    Widget? actionWidget,
    PreferredSizeWidget? bottom,
    automaticallyImplyLeading: true}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(bottom != null ? 88 : 44),
      child: AppBar(
        title: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: elevation,
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          if (actionWidget != null)
            Align(alignment: Alignment.center, child: actionWidget),
          const SizedBox(width: 15)
        ],
        bottom: bottom,
      ));
}