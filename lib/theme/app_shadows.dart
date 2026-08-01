import 'package:flutter/material.dart';
import 'color_style.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card(Brightness brightness) => [
    BoxShadow(
      color: brightness == Brightness.dark
          ? AppColors.darkShadow
          : AppColors.shadow,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
