import 'package:flutter/material.dart';

class ChapterData {
  final String eyebrow;
  final String title;
  final String body;
  final String? pullQuote;
  final IconData icon;

  const ChapterData({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.icon,
    this.pullQuote,
  });
}

class Particle {
  final double startX;
  final double size;
  final double drift;
  final double phase;

  const Particle({
    required this.startX,
    required this.size,
    required this.drift,
    required this.phase,
  });
}
