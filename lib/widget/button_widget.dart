import 'package:flutter/material.dart';

///带背景色的按钮
Widget elevatedBtn(String text,
    {TextStyle textStyle: const TextStyle(fontSize: 16, color: Colors.white),
    Color backgroundColor: Colors.blue,
    onLongPress,
    onPress,
    double radius: 18,
    Widget? childWidget,
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6)}) {
  return ElevatedButton(
      onPressed: onPress,
      onLongPress: onLongPress,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)))),
      child: childWidget == null
          ? Text(
              text,
              style: textStyle,
            )
          : childWidget);
}

///带边框的按钮
Widget outlineBtn(String text, Color sideColor, onClick,
    {TextStyle textStyle: const TextStyle(fontSize: 16, color: Colors.blue),
    double radius: 18,
    Color backgroundColor: Colors.transparent,
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6)}) {
  return OutlinedButton(
      onPressed: onClick,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          side:
              MaterialStateProperty.all(BorderSide(width: 1, color: sideColor)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)))),
      child: Text(
        text,
        style: textStyle,
      ));
}
