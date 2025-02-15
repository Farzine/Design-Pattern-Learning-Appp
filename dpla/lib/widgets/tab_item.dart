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
