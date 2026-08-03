import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_shadows.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_play_pause_button.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/recitation_drop_down.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_speed_widget.dart';
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
        AppSnackBarService.error(message, duration: const Duration(seconds: 3));
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

  Future<void> _loadSyncForSelectedRecitation() async {
    final recitation = widget.controller.selectedRecitation;
    if (recitation == null || recitation.xmlText.isEmpty) return;
    await widget.verseSyncController?.loadSyncPoints(recitation.xmlText);
  }

  Future<void> _loadIfNeeded() async {
    final ctrl = widget.controller;
    if (_initialized &&
        ctrl.lastId == widget.id &&
        ctrl.lastAudioUrl == widget.audioUrl) {
      return;
    }

    await ctrl.loadRecitations(widget.id, widget.category);

    final storage = Get.find<IAudioDownloadStorage>();
    final resolver = Get.find<AudioSourceResolver>();

    String? reciterKey;
    String onlineUrl = '';

    if (ctrl.selectedRecitation != null) {
      reciterKey = ReciterKey.from(ctrl.selectedRecitation!.audioArtist);
      onlineUrl = ctrl.selectedRecitation!.mp3Url;
    } else {
      final downloaded = await storage.getDownloadsForPoem(
        widget.id,
        widget.category,
      );
      if (downloaded.isNotEmpty) {
        final defaultReciter = await storage.getDefaultReciter(widget.category);
        final match = downloaded.firstWhere(
          (d) => d.reciterKey == defaultReciter?.reciterKey,
          orElse: () => downloaded.first,
        );
        reciterKey = match.reciterKey;
        onlineUrl = match.sourceUrl;
      }
    }

    if (reciterKey == null) {
      await ctrl.load(
        id: widget.id,
        audioUrl: widget.audioUrl,
        title: widget.title,
        fetchAudioUrl: widget.fetchAudioUrl,
      );
      await _loadSyncForSelectedRecitation();
      return;
    }

    _initialized = true;

    await ctrl.loadWithSourceResolution(
      id: widget.id,
      poemCategory: widget.category,
      reciterKey: reciterKey,
      onlineUrl: onlineUrl,
      resolver: resolver,
      title: widget.title,
      onSyncXmlResolved: (xml) {
        widget.verseSyncController?.loadSyncPoints(xml);
      },
      onSyncUnavailable: () {
        widget.verseSyncController?.clearSyncPoints();
      },
    );

    // Online streams don't carry sync XML in the resolver; load from recitation metadata.
    await _loadSyncForSelectedRecitation();
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

    if (!ctrl.hasPreparedAudio) {
      AppSnackBarService.error(
        'بارگیری فایل صوتی انجام نشد',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    await ctrl.seek(position);

    if (!ctrl.isPlaying) {
      await ctrl.playOrPause();
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
        borderRadius: AppRadius.lgRadius,
        onTap: _expand,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.lgRadius,
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
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
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
          borderRadius: AppRadius.xxlRadius,
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
          boxShadow: AppShadows.card(context),
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
                onChanged: ctrl.hasPreparedAudio
                    ? (v) => ctrl.seek(Duration(milliseconds: v.toInt()))
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                        color: ctrl.hasPreparedAudio
                            ? cs.error
                            : theme.disabledColor,

                        onPressed: ctrl.hasPreparedAudio ? ctrl.stop : null,
                        tooltip: 'توقف',
                      ),
                      const SizedBox(width: 22),
                      PlayPauseButton(
                        ctrl: ctrl,
                        cs: cs,
                        theme: theme,
                        onTap: () async {
                          if (!_initialized) {
                            await _loadIfNeeded();
                            if (!mounted) return;
                          }
                          await ctrl.playOrPause();
                        },
                      ),
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
