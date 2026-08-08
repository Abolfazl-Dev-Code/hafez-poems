import 'package:flutter/material.dart';

class MenuItemData {
  final Widget Function(Color color) iconBuilder;
  final String label;
  final VoidCallback onTap;

  const MenuItemData({
    required this.iconBuilder,
    required this.label,
    required this.onTap,
  });
}
