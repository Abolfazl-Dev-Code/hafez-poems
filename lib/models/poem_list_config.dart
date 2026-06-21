import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hafez_poems/screens/poem_screen.dart';

class PoemListConfig {
  final String headerTitle;
  final String loadingText;
  final String emptyText;
  final String? tilePrefix;

  final RxList items;
  final RxBool isIndexing;
  final RxDouble loadingProgress;

  final Future<void> Function(String id) prefetch;
  final PoemScreenArgs Function(BasePoem item) buildArgs;
  final VoidCallback onRetry;

  const PoemListConfig({
    required this.headerTitle,
    required this.loadingText,
    required this.emptyText,
    required this.items,
    required this.isIndexing,
    required this.loadingProgress,
    required this.prefetch,
    required this.buildArgs,
    required this.onRetry,
    this.tilePrefix,
  });
}
