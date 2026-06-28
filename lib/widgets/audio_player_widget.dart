// lib/widgets/audio_player_widget.dart
//
// ── تغییرات نسبت به نسخه قبل ──
//   ۱. Dropdown انتخاب خواننده بالای اسلایدر
//   ۲. دکمه‌های سرعت پخش (0.5 / 1.0 / 1.5 / 2.0)
//   ۳. نشانگر «فایل صوتی موجود نیست» وقتی recitations خالی باشد
//   ۴. اصلاح راست‌چین شدن لیست خوانندگان هنگام باز شدن Dropdown
//
// ── بقیه منطق (اسلایدر، play/pause، stop) دست نخورده است ──

import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/audio_player_controller.dart';
import 'package:hafez_poems/controllers/verse_sync_controller.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/widgets/audio_play_pause_button.dart';
import 'package:hafez_poems/widgets/audio_poem_readers_widget.dart';
import 'package:hafez_poems/widgets/audio_speed_widget.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String id;
  final String audioUrl;
  final String title;
  final Future<String> Function(String id)? fetchAudioUrl;
  final AudioPlayerController controller;
  final VerseSyncController? verseSyncController; // ← اضافه کن
  final void Function(RecitationInfo recitation)?
  onRecitationChanged; // ← اضافه

  const AudioPlayerWidget({
    super.key,
    required this.id,
    required this.audioUrl,
    required this.title,
    required this.controller,
    this.fetchAudioUrl,
    this.verseSyncController, // ← اضافه کن
    this.onRecitationChanged, // ← اضافه
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    widget.controller.setupListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadIfNeeded();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget old) {
    super.didUpdateWidget(old);
    final changed =
        old.id != widget.id ||
        old.audioUrl != widget.audioUrl ||
        old.title != widget.title;
    if (changed) {
      _initialized = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadIfNeeded();
      });
    }
  }

  Future<void> _loadIfNeeded() async {
    debugPrint('🚀 _loadIfNeeded called — id: ${widget.id}');
    final ctrl = widget.controller;
    if (_initialized &&
        ctrl.lastId == widget.id &&
        ctrl.lastAudioUrl == widget.audioUrl) {
      debugPrint('⏭️ skipped — already initialized');
      return;
    }

    _initialized = true;

    await ctrl.loadRecitations(widget.id);

    debugPrint('✅ recitations count: ${ctrl.recitations.length}');
    debugPrint('✅ selectedRecitation: ${ctrl.selectedRecitation?.audioArtist}');

    debugPrint('SYNC_CHECK_1');
    debugPrint(
      'SYNC_CHECK_2 verseSyncCtrl=${widget.verseSyncController != null}',
    );
    debugPrint('SYNC_CHECK_3 recitation=${ctrl.selectedRecitation?.id}');

    if (widget.verseSyncController != null &&
        ctrl.selectedRecitation != null &&
        ctrl.selectedRecitation!.xmlText.isNotEmpty) {
      widget.verseSyncController!.loadSyncPoints(
        ctrl.selectedRecitation!.xmlText, // ← به جای id
      );
    } else {
      debugPrint('SYNC_CHECK_5 SKIPPED');
    }

    final selectedUrl = ctrl.selectedRecitation?.mp3Url ?? widget.audioUrl;

    await ctrl.load(
      id: widget.id,
      audioUrl: selectedUrl,
      title: widget.title,
      fetchAudioUrl: ctrl.selectedRecitation != null
          ? null
          : widget.fetchAudioUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;

        final maxMs = ctrl.duration.inMilliseconds > 0
            ? ctrl.duration.inMilliseconds.toDouble()
            : 1.0;
        final currentMs = ctrl.position.inMilliseconds.toDouble().clamp(
          0.0,
          maxMs,
        );

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.18 : 0.08,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── ۱. انتخاب خواننده ──────────────────────────
                RecitationDropdown(
                  ctrl: ctrl,
                  poemId: widget.id,
                  theme: theme,
                  cs: cs,
                  onRecitationChanged: widget.onRecitationChanged, // ← اضافه
                ),

                const SizedBox(height: 4),

                // ── ۲. Slider ────────────────────────────────────
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    activeTrackColor: cs.primary,
                    inactiveTrackColor: theme.dividerColor.withValues(
                      alpha: 0.6,
                    ),
                    thumbColor: cs.primary,
                    overlayColor: cs.primary.withValues(alpha: 0.15),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16.0,
                    ),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: maxMs,
                    value: currentMs,
                    onChanged: ctrl.isAudioLoaded
                        ? (v) => ctrl.seek(Duration(milliseconds: v.toInt()))
                        : null,
                  ),
                ),

                // ── ۳. زمان ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ctrl.formatDuration(ctrl.position),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                      Text(
                        ctrl.formatDuration(ctrl.duration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0),

                // ── ۵. دکمه‌های کنترل + سرعت پخش در گوشه ────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── stop و play/pause دقیقاً وسط ──
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.stop_circle_outlined),
                            iconSize: 40,
                            color: ctrl.isAudioLoaded
                                ? cs.error
                                : theme.disabledColor,
                            onPressed: ctrl.isAudioLoaded ? ctrl.stop : null,
                            tooltip: 'توقف',
                          ),
                          const SizedBox(width: 22),
                          PlayPauseButton(ctrl: ctrl, cs: cs, theme: theme),
                        ],
                      ),
                    ),

                    // ── سرعت پخش — گوشه راست ──
                    Positioned(
                      right: 10,
                      child: SpeedButtons(ctrl: ctrl, cs: cs, theme: theme),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
