import 'package:flutter/material.dart';

class SlideData {
  final IconData icon;
  final String title;
  final String subtitle;

  final Color lightBgTop;
  final Color lightBgBottom;
  final Color darkBgTop;
  final Color darkBgBottom;

  final Color lightAccent;
  final Color darkAccent;

  const SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.lightBgTop,
    required this.lightBgBottom,
    required this.darkBgTop,
    required this.darkBgBottom,
    required this.lightAccent,
    required this.darkAccent,
  });
}
