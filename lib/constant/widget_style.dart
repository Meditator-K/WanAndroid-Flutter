import 'dart:math';

import 'package:flutter/material.dart';

class WidgetStyle {
  static const BTN_STYLE = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  static const DRAWER_TEXT_STYLE = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  static const TREE_TITLE_TEXT_STYLE = TextStyle(
      fontSize: 16.0,
      color: Colors.black87,
      fontWeight: FontWeight.bold);

  static const TREE_TITLE_TEXT_STYLE2 = TextStyle(
      fontSize: 16.0, color: Colors.black26, fontWeight: FontWeight.bold);

  static const COMMON_SEARCH_TEXT_STYLE = TextStyle(
      fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold);

  static Color getRandomColor() {
    List<int> values = [];
    for (int i = 110; i < 210; i++) {
      values.add(i);
    }
    return Color.fromARGB(
        255, values[getRandom()], values[getRandom()], values[getRandom()]);
  }

  static int getRandom() {
    return Random().nextInt(99);
  }
}
