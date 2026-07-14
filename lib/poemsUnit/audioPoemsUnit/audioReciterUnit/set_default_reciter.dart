import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';

class DefaultReciterStar extends StatefulWidget {
  final String poemId;
  final String reciterKey;
  final ColorScheme cs;

  const DefaultReciterStar({
    super.key,
    required this.poemId,
    required this.reciterKey,
    required this.cs,
  });

  @override
  State<DefaultReciterStar> createState() => _DefaultReciterStarState();
}

class _DefaultReciterStarState extends State<DefaultReciterStar> {
  bool _isDefault = false;
  late final IAudioDownloadStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = Get.find<IAudioDownloadStorage>();
    _load();
  }

  Future<void> _load() async {
    final key = await _storage.getDefaultReciter(widget.poemId);
    if (mounted) setState(() => _isDefault = key == widget.reciterKey);
  }

  Future<void> _toggle() async {
    await _storage.setDefaultReciter(widget.poemId, widget.reciterKey);
    if (mounted) setState(() => _isDefault = true);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isDefault ? Icons.star_rounded : Icons.star_border_rounded,
        size: 20,
        color: _isDefault
            ? Colors.amber.shade600
            : widget.cs.onSurface.withValues(alpha: 0.4),
      ),
      onPressed: _isDefault ? null : _toggle,
    );
  }
}
