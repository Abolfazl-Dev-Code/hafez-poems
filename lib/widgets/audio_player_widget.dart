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
                _RecitationDropdown(
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
                const SizedBox(height: 4),

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
                            iconSize: 46,
                            color: ctrl.isAudioLoaded
                                ? cs.error
                                : theme.disabledColor,
                            onPressed: ctrl.isAudioLoaded ? ctrl.stop : null,
                            tooltip: 'توقف',
                          ),
                          const SizedBox(width: 22),
                          _PlayPauseButton(ctrl: ctrl, cs: cs, theme: theme),
                        ],
                      ),
                    ),

                    // ── سرعت پخش — گوشه راست ──
                    Positioned(
                      right: 0,
                      child: _SpeedButtons(ctrl: ctrl, cs: cs, theme: theme),
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

// ── Dropdown خواننده — راست‌چین صحیح در حالت باز و بسته ──────────────────

class _RecitationDropdown extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged; // ← اضافه
  const _RecitationDropdown({
    required this.ctrl,
    required this.poemId,
    required this.theme,
    required this.cs,
    this.onRecitationChanged, // ← اضافه
  });

  @override
  Widget build(BuildContext context) {
    // در حال بارگذاری
    if (ctrl.isLoadingRecitations) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'دریافت خوانندگان...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    // فایل صوتی موجود نیست
    if (ctrl.recitations.isEmpty) {
      return Container(
        height: 36,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 16,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 6),
            Text(
              textAlign: TextAlign.center,
              'فایل صوتی برای این شعر موجود نیست \n یا اتصال شما به اینترنت کند است',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    // فقط یک خواننده — نمایش ساده بدون dropdown
    if (ctrl.recitations.length == 1) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 15,
              color: cs.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                ctrl.recitations.first.audioArtist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // چند خواننده — Dropdown
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<RecitationInfo>(
            value: ctrl.selectedRecitation,
            isExpanded: true,
            alignment: AlignmentDirectional.centerEnd, // ← راست‌چین دکمه‌ی بسته
            icon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: cs.primary,
              ),
            ),
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
            dropdownColor: cs.surface,
            borderRadius: BorderRadius.circular(12),
            // ── نمایش مقدار انتخاب‌شده در حالت بسته (راست‌چین) ──
            selectedItemBuilder: (context) {
              return ctrl.recitations.map((r) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mic_rounded,
                        size: 14,
                        color: cs.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          r.audioArtist,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            // ── آیتم‌های لیست باز شده (راست‌چین) ──
            items: ctrl.recitations.map((r) {
              return DropdownMenuItem<RecitationInfo>(
                alignment: AlignmentDirectional.centerEnd, // ← راست‌چین هر آیتم
                value: r,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mic_rounded,
                      size: 14,
                      color: cs.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        r.audioArtist,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: ctrl.isLoadingRecitations
                ? null
                : (recitation) {
                    if (recitation == null) return;
                    ctrl.selectRecitation(poemId, recitation);
                    onRecitationChanged?.call(recitation); // ← اضافه
                  },
          ),
        ),
      ),
    );
  }
}

// ── دکمه‌های سرعت پخش ──────────────────────────────────────────────────

class _SpeedButtons extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ColorScheme cs;
  final ThemeData theme;

  const _SpeedButtons({
    required this.ctrl,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      enabled: ctrl.isAudioLoaded,
      onSelected: (speed) => ctrl.setPlaybackSpeed(speed),
      offset: const Offset(0, -160),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: cs.surface,
      tooltip: 'سرعت پخش',
      itemBuilder: (_) => AudioPlayerController.supportedSpeeds.map((speed) {
        final isSelected = ctrl.playbackSpeed == speed;
        return PopupMenuItem<double>(
          value: speed,
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_rounded : null,
                size: 18,
                color: cs.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${speed}x',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: ctrl.isAudioLoaded
              ? cs.surfaceContainerHighest.withValues(alpha: 0.6)
              : cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Text(
          '${ctrl.playbackSpeed}x',
          style: theme.textTheme.labelMedium?.copyWith(
            color: ctrl.isAudioLoaded
                ? cs.onSurface.withValues(alpha: 0.75)
                : cs.onSurface.withValues(alpha: 0.35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ── دکمه Play/Pause — دست نخورده ──────────────────────────────────────────

class _PlayPauseButton extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ColorScheme cs;
  final ThemeData theme;

  const _PlayPauseButton({
    required this.ctrl,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = ctrl.isAudioLoaded && !ctrl.isLoadingAudio;

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: enabled ? cs.primary : theme.disabledColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: enabled ? 0.25 : 0.0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: ctrl.isPlaying ? 'مکث' : 'پخش',
        icon: ctrl.isLoadingAudio
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: cs.onPrimary,
                ),
              )
            : Icon(
                ctrl.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 32,
              ),
        color: cs.onPrimary,
        onPressed: enabled ? ctrl.togglePlayPause : null,
      ),
    );
  }
}
