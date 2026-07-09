import 'package:flutter/material.dart';

class MenuItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
