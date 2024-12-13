// //tab_item.dart
// import 'package:flutter/material.dart';

// class TabItem {
//   IconData icon;
//   String title;
//   Color circleColor;
//   Color? circleStrokeColor;
//   TextStyle labelStyle;

//   TabItem(
//     this.icon,
//     this.title,
//     this.circleColor, MaterialAccentColor blueAccent, TextStyle textStyle, {
//     this.circleStrokeColor,
//     this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
//   });
// }


// lib/widgets/tab_item.dart

import 'package:flutter/material.dart';

class TabItem {
  final IconData icon;
  final String title;
  final Color circleColor;
  final Color? circleStrokeColor;
  final TextStyle labelStyle;

  TabItem(
    this.icon,
    this.title,
    this.circleColor, {
    this.circleStrokeColor,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
  });
}
