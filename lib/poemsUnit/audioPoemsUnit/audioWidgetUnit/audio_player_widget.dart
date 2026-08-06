import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_shadows.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_collapsed_bar.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/recitation_drop_down.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_progress_slider.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_transport_controls.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';

part 'audio_player_widget_loader.dart';

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
              : AudioCollapsedBar(onTap: _expand),
        );
      },
    );
  }

  Widget _buildExpandedPlayer(
    BuildContext context,
    AudioPlayerController ctrl,
    ThemeData theme,
    ColorScheme cs,
  ) {
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
            AudioProgressSlider(ctrl: ctrl, theme: theme, cs: cs),
            const SizedBox(height: 0),
            AudioTransportControls(
              ctrl: ctrl,
              theme: theme,
              cs: cs,
              onPlayPauseTap: () async {
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
    );
  }
}
