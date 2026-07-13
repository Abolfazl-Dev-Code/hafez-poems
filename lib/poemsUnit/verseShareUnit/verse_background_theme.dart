import 'package:flutter/material.dart';

class VerseBackgroundTheme {
  final String label;
  final String assetPath;
  final Color textColor;
  final Color titleColor;
  final List<Color> overlayColors;

  const VerseBackgroundTheme({
    required this.label,
    required this.assetPath,
    required this.textColor,
    required this.titleColor,
    required this.overlayColors,
  });

  BoxDecoration get decoration {
    return BoxDecoration(
      image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
    );
  }

  BoxDecoration get overlayDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: overlayColors,
      ),
    );
  }
}

class VerseBackgroundThemes {
  static const List<VerseBackgroundTheme> all = [
    VerseBackgroundTheme(
      label: "Turquoise",
      assetPath: "assets/images/blue-bg-poem.png",
      textColor: Colors.white,
      titleColor: Color(0xFFE7F9FF),
      overlayColors: [Color(0x22000000), Color(0x44000000), Color(0x66000000)],
    ),

    VerseBackgroundTheme(
      label: "Emerald",
      assetPath: "assets/images/red-bg-poem.png",
      textColor: Colors.white,
      titleColor: Color(0xFFEFFFF5),
      overlayColors: [Color(0x22000000), Color(0x55000000), Color(0x77000000)],
    ),

    VerseBackgroundTheme(
      label: "Persian Plum",
      assetPath: "assets/images/green-bg-poem.png",
      textColor: Colors.white,
      titleColor: Color(0xFFFFEDED),
      overlayColors: [Color(0x33000000), Color(0x66000000), Color(0x88000000)],
    ),
  ];

  static VerseBackgroundTheme byIndex(int index) {
    return all[index % all.length];
  }

  static int get length => all.length;
}
