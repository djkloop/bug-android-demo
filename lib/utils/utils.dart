import 'package:flutter/material.dart';

class Util {
  static Widget wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if(callback != null) callback();
      },
      child: child,
    );
  }

  static Color colorUtil(String hex) {
    return Color(int.parse('0xff' + hex));
  }
}