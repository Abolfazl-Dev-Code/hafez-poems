import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/widgets/ghazal_action_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/ghazal_action_controller.dart';

class PoemScreenArgs {
  final String id;
  final String title;
  final String text;
  final String audioUrl;
  final Future<String> Function(String id) fetchText;
  final Future<String> Function(String id)? fetchAudioUrl;

  const PoemScreenArgs({
    required this.id,
    required this.title,
    required this.text,
    required this.fetchText,
    this.audioUrl = '',
    this.fetchAudioUrl,
  });

  bool get hasAudio => audioUrl.isNotEmpty || fetchAudioUrl != null;
}

class PoemScreen extends StatefulWidget {
  final PoemScreenArgs args;

  const PoemScreen({super.key, required this.args});

  @override
  State<PoemScreen> createState() => _PoemScreenState();
}

class _PoemScreenState extends State<PoemScreen> {
  String _poemText = '';
  bool _isTextLoading = true;
  String _textError = '';
  static const String _fontSizeKey = 'reading_font_size';
  static const String _lineHeightKey = 'reading_line_height';
  static const String _fontFamilyKey = 'reading_font_family';
  static const String _fontColorKey = 'reading_font_color';

  double _fontSize = 20;
  double _lineHeight = 1.9;
  String _fontFamily = 'Vazir';
  Color _fontColor = Colors.black;
  final GhazalActionController _actionController = GhazalActionController();
  bool _isLiked = false;
  bool _isSaved = false;
  int? _selectedLineIndex;
  final Set<int> _highlightedLineIndexes = {};
  AudioPlayer? _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<void>? _completeSub;

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isAudioLoaded = false;
  bool _isLoadingAudio = false;
  PoemScreenArgs get _args => widget.args;

  List<String> get _poemLines => _poemText
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool get _isSelectedLineHighlighted =>
      _selectedLineIndex != null &&
      _highlightedLineIndexes.contains(_selectedLineIndex);
  @override
  void initState() {
    super.initState();
    _loadReadingSettings();
    _loadInitialActionsState();
    _initText();

    if (_args.hasAudio || _args.fetchAudioUrl != null) {
      _audioPlayer = AudioPlayer();
      _setupAudioListeners();
      _loadAudio();
    }
  }

  void _initText() {
    if (_args.text.isNotEmpty) {
      _poemText = _args.text;
      _isTextLoading = false;
    } else {
      _fetchPoemText();
    }
  }

  Future<void> _loadReadingSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _fontSize = prefs.getDouble(_fontSizeKey) ?? 20;
      _lineHeight = prefs.getDouble(_lineHeightKey) ?? 1.9;
      _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Vazir';
      _fontColor = Color(prefs.getInt(_fontColorKey) ?? 0xFF000000);
    });
  }

  Future<void> _fetchPoemText() async {
    setState(() {
      _isTextLoading = true;
      _textError = '';
    });
    try {
      final text = await _args.fetchText(_args.id);
      if (!mounted) return;
      setState(() {
        _poemText = text;
        _isTextLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _textError = 'خطا در دریافت متن';
        _isTextLoading = false;
      });
    }
  }

  void _loadInitialActionsState() {
    _isLiked = _actionController.isLiked(_args.id);
    _isSaved = _actionController.isSaved(_args.id);
    _highlightedLineIndexes.addAll(
      _actionController.getHighlightedLineIndexes(_args.id),
    );
  }

  void _setupAudioListeners() {
    final player = _audioPlayer!;

    _playerStateSub = player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
    });

    _durationSub = player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });

    _positionSub = player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });

    _completeSub = player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _loadAudio() async {
    setState(() {
      _isLoadingAudio = true;
      _isAudioLoaded = false;
    });

    try {
      await _audioPlayer!.stop();
      await _audioPlayer!.release();
      // ignore: empty_catches
    } catch (e) {}

    String url = _args.audioUrl;

    if (url.isEmpty && _args.fetchAudioUrl != null) {
      try {
        url = await _args.fetchAudioUrl!(_args.id).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return '';
          },
        );
        // ignore: empty_catches
      } catch (e) {}
    }

    if (url.isEmpty) {
      if (!mounted) return;
      setState(() => _isLoadingAudio = false);
      return;
    }

    try {
      await _audioPlayer!.setSourceUrl(url);
      if (!mounted) return;
      setState(() {
        _isAudioLoaded = true;
        _isLoadingAudio = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingAudio = false);
    }
  }

  Future<void> _stopAudio() async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.stop();
    if (!mounted) return;
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  Future<void> _seekAudio(Duration position) async {
    if (!_isAudioLoaded) return;
    await _audioPlayer!.seek(position);
  }

  Future<void> _toggleLike() async {
    await _actionController.toggleLike(
      ghazalId: _args.id,
      title: _args.title,
      text: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) setState(() => _isLiked = _actionController.isLiked(_args.id));
  }

  Future<void> _toggleSave() async {
    await _actionController.toggleSave(
      ghazalId: _args.id,
      title: _args.title,
      text: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) setState(() => _isSaved = _actionController.isSaved(_args.id));
  }

  Future<void> _toggleHighlight() async {
    if (_selectedLineIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً ابتدا یک بیت را انتخاب کنید')),
      );
      return;
    }

    final index = _selectedLineIndex!;
    final lineText = _poemLines[index];

    await _actionController.toggleHighlight(
      ghazalId: _args.id,
      ghazalTitle: _args.title,
      ghazalText: _poemText,
      audioUrl: _args.audioUrl,
      highlightedLine: lineText,
      lineIndex: index,
      color: const Color(0xFFFFC107),
    );

    if (!mounted) return;
    setState(() {
      if (_actionController.isLineHighlighted(_args.id, index)) {
        _highlightedLineIndexes.add(index);
      } else {
        _highlightedLineIndexes.remove(index);
      }
    });
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final double bottomPadding = _args.hasAudio ? 250 : 110;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(_args.title, style: textTheme.headlineMedium),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (_args.hasAudio) await _stopAudio();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: _isTextLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _textError.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _textError,
                            style: TextStyle(color: colorScheme.error),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _fetchPoemText,
                            child: const Text('تلاش مجدد'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                      child: Card(
                        color: colorScheme.surface,
                        elevation: isDark ? 0 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: List.generate(_poemLines.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _PoemLineTile(
                                  text: _poemLines[i],
                                  isSelected: _selectedLineIndex == i,
                                  isHighlighted: _highlightedLineIndexes
                                      .contains(i),
                                  fontSize: _fontSize,
                                  lineHeight: _lineHeight,
                                  fontFamily: _fontFamily,
                                  fontColor: _fontColor,
                                  onTap: () => setState(() {
                                    _selectedLineIndex = _selectedLineIndex == i
                                        ? null
                                        : i;
                                  }),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: _args.hasAudio ? 180 : 30,
              child: GhazalActionBar(
                isLiked: _isLiked,
                isSaved: _isSaved,
                canHighlight: _selectedLineIndex != null,
                isHighlightActive: _isSelectedLineHighlighted,
                onLikeTap: _toggleLike,
                onSaveTap: _toggleSave,
                onHighlightTap: _toggleHighlight,
                scaffoldContext: context,
              ),
            ),
            if (_args.hasAudio)
              _buildAudioPlayer(theme, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final double maxSliderValue = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;

    final double currentSliderValue = _position.inMilliseconds.toDouble().clamp(
      0.0,
      maxSliderValue,
    );

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          decoration: BoxDecoration(
            color: colorScheme.surface,
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
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  activeTrackColor: colorScheme.primary,
                  inactiveTrackColor: theme.dividerColor.withValues(alpha: 0.6),
                  thumbColor: colorScheme.primary,
                  overlayColor: colorScheme.primary.withValues(alpha: 0.15),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7.0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16.0,
                  ),
                ),
                child: Slider(
                  min: 0.0,
                  max: maxSliderValue,
                  value: currentSliderValue,
                  onChanged: !_isAudioLoaded
                      ? null
                      : (v) => _seekAudio(Duration(milliseconds: v.toInt())),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop_circle_outlined),
                      iconSize: 46,
                      color: colorScheme.error,
                      onPressed: _isAudioLoaded ? _stopAudio : null,
                    ),
                    const SizedBox(width: 22),
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: _isAudioLoaded
                            ? colorScheme.primary
                            : theme.disabledColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: _isLoadingAudio
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Icon(
                                _playerState == PlayerState.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 32,
                              ),
                        color: colorScheme.onPrimary,
                        onPressed: !_isAudioLoaded
                            ? null
                            : () {
                                if (_playerState == PlayerState.playing) {
                                  _audioPlayer!.pause();
                                } else {
                                  _audioPlayer!.resume();
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(duration.inMinutes.remainder(60))}:${two(duration.inSeconds.remainder(60))}';
  }
}

class _PoemLineTile extends StatelessWidget {
  const _PoemLineTile({
    required this.text,
    required this.isSelected,
    required this.isHighlighted,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontColor,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final bool isHighlighted;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color fontColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bg = Colors.transparent;
    Color border = Colors.transparent;
    Color textColor = colorScheme.onSurface;

    if (isHighlighted) {
      bg = const Color(0xFFFFF3B0);
      border = const Color(0xFFFFC107);
      textColor = Colors.black87;
    } else if (isSelected) {
      bg = colorScheme.primary.withValues(alpha: 0.08);
      border = colorScheme.primary.withValues(alpha: 0.45);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: fontSize,
                height: lineHeight,
                fontFamily: fontFamily,
                color: isHighlighted ? textColor : fontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
