import 'package:flutter/material.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_play_pause_button.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/recitation_drop_down.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_speed_widget.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';
import 'package:hafez_poems/theme/color_style.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String id;
  final String audioUrl;
  final String category;
  final String title;
  final Future<String> Function(String id)? fetchAudioUrl;
  final AudioPlayerController controller;
  final VerseSyncController? verseSyncController;
  final void Function(RecitationInfo recitation)? onRecitationChanged;
  final ValueChanged<bool>? onExpansionChanged;

  const AudioPlayerWidget({
    super.key,
    required this.id,
    required this.audioUrl,
    required this.category,
    required this.title,
    required this.controller,
    this.fetchAudioUrl,
    this.verseSyncController,
    this.onRecitationChanged,
    this.onExpansionChanged,
  });

  @override
  State<AudioPlayerWidget> createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _initialized = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.controller.setupListeners();

    widget.controller.onUserMessage = (message) {
      if (mounted) {
        AppSnackBarService.error(
          context,
          message,
          duration: Duration(milliseconds: 1000),
        );
      }
    };
  }

  @override
  void dispose() {
    widget.controller.onUserMessage = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.id != widget.id ||
        oldWidget.audioUrl != widget.audioUrl ||
        oldWidget.title != widget.title;
    if (changed) {
      _initialized = false;
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
        ctrl.selectedRecitation!.xmlText,
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

  Future<void> prepareForPlay() async {
    if (!_isExpanded) {
      await _expand();
    }

    if (!_initialized) {
      await _loadIfNeeded();
    }
  }

  Future<void> playFromPosition(Duration position) async {
    final ctrl = widget.controller;

    await prepareForPlay();

    if (!mounted) return;

    if (!ctrl.isAudioLoaded) {
      AppSnackBarService.error(context, 'بارگیری فایل صوتی انجام نشد');
      return;
    }

    await ctrl.seek(position);

    if (!ctrl.isPlaying) {
      await ctrl.togglePlayPause();
    }
  }

  Future<void> _expand() async {
    if (_isExpanded) return;

    setState(() => _isExpanded = true);
    widget.onExpansionChanged?.call(true);

    if (!_initialized) {
      await _loadIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;

        return AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomCenter,
          child: _isExpanded
              ? _buildExpandedPlayer(context, ctrl, theme, cs)
              : _buildCollapsedBar(),
        );
      },
    );
  }

  Widget _buildCollapsedBar() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _expand,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'پخش صوتی',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedPlayer(
    BuildContext context,
    AudioPlayerController ctrl,
    ThemeData theme,
    ColorScheme cs,
  ) {
    final maxMs = ctrl.duration.inMilliseconds > 0
        ? ctrl.duration.inMilliseconds.toDouble()
        : 1.0;
    final currentMs = ctrl.position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
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
            RecitationDropdown(
              ctrl: ctrl,
              poemId: widget.id,
              category: widget.category,
              poemTitle: widget.title,
              theme: theme,
              cs: cs,
              onRecitationChanged: widget.onRecitationChanged,
            ),
            const SizedBox(height: 4),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                activeTrackColor: cs.primary,
                inactiveTrackColor: theme.dividerColor.withValues(alpha: 0.6),
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
            Stack(
              alignment: Alignment.center,
              children: [
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
  }
}
