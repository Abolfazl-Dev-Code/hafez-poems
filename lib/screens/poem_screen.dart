// lib/screens/poem_screen.dart

import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/audio_player_controller.dart';
import 'package:hafez_poems/controllers/verse_sync_controller.dart';
import 'package:hafez_poems/widgets/audio_player_widget.dart';
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
  final int? highlightLineIndex; // ← اضافه

  const PoemScreenArgs({
    required this.id,
    required this.title,
    required this.text,
    required this.fetchText,
    this.audioUrl = '',
    this.fetchAudioUrl,
    this.highlightLineIndex, // ← اضافه
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
  late final AudioPlayerController _audioCtrl = AudioPlayerController();
  late final VerseSyncController _verseSyncCtrl = VerseSyncController();
  final Map<int, GlobalKey> _lineKeys = {};
  int? _flashingLineIndex;
  String _poemText = '';
  bool _isTextLoading = true;
  String _textError = '';
  final ScrollController _scrollController = ScrollController();
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

  PoemScreenArgs get _args => widget.args;

  List<String> get _poemLines => _poemText
      .split('\n')
      .expand((line) {
        if (line.contains(' / ')) {
          return line.split(' / ');
        }
        return [line];
      })
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool get _isSelectedLineHighlighted =>
      _selectedLineIndex != null &&
      _highlightedLineIndexes.contains(_selectedLineIndex);

  @override
  void initState() {
    super.initState();
    _audioCtrl.addListener(_syncPosition);
    _loadReadingSettings();
    _loadInitialActionsState();
    _initText();
  }

  void _syncPosition() {
    debugPrint(
      '🎵 position: ${_audioCtrl.position}, hasSyncData: ${_verseSyncCtrl.hasSyncData}, activeOrder: ${_verseSyncCtrl.activeVerseOrder}',
    );
    _verseSyncCtrl.updatePosition(_audioCtrl.position);
  }

  void _initText() {
    if (_args.text.isNotEmpty) {
      _poemText = _args.text;
      _isTextLoading = false;
      _scheduleScrollToHighlight();
    } else {
      _fetchPoemText();
    }
  }

  Future<void> _loadReadingSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _fontSize = prefs.getDouble(_fontSizeKey) ?? 13;
      _lineHeight = prefs.getDouble(_lineHeightKey) ?? 1;
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
      _scheduleScrollToHighlight();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _textError = 'خطا در دریافت متن';
        _isTextLoading = false;
      });
    }
  }

  void _scheduleScrollToHighlight() {
    final targetIndex = _args.highlightLineIndex;
    if (targetIndex == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final key = _lineKeys[targetIndex];
      final ctx = key?.currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      final scrollBox = _scrollController.hasClients
          ? _scrollController.position.context.storageContext.findRenderObject()
                as RenderBox?
          : null;

      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      if (box != null &&
          _scrollController.hasClients &&
          scrollBox != null &&
          scrollBox.attached) {
        final tileOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
        final screenHeight = scrollBox.size.height;
        final targetOffset =
            (_scrollController.offset + tileOffset.dy - screenHeight / 3).clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            );

        await _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      if (!mounted) return;
      setState(() => _flashingLineIndex = targetIndex);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _flashingLineIndex = null);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _flashingLineIndex = targetIndex);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _flashingLineIndex = null);
    });
  }

  void _loadInitialActionsState() {
    _isLiked = _actionController.isLiked(_args.id);
    _isSaved = _actionController.isSaved(_args.id);
    _highlightedLineIndexes.addAll(
      _actionController.getHighlightedLineIndexes(_args.id),
    );
  }

  Future<void> _toggleLike() async {
    await _actionController.toggleLike(
      ghazalId: _args.id,
      title: _args.title,
      text: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      setState(() => _isLiked = _actionController.isLiked(_args.id));
    }
  }

  Future<void> _toggleSave() async {
    await _actionController.toggleSave(
      ghazalId: _args.id,
      title: _args.title,
      text: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      setState(() => _isSaved = _actionController.isSaved(_args.id));
    }
  }

  Future<void> _toggleHighlight() async {
    if (_selectedLineIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً ابتدا یک مصرع را انتخاب کنید')),
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
    _scrollController.dispose(); // ← اضافه
    _audioCtrl.removeListener(_syncPosition);
    _audioCtrl.dispose();
    _verseSyncCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final double bottomPadding = _args.hasAudio ? 258 : 110;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(_args.title, style: textTheme.headlineMedium),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (_args.hasAudio) await _audioCtrl.stop();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            // ── متن شعر ──────────────────────────────────────────
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
                      controller: _scrollController, // ← اضافه
                      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                      child: Card(
                        color: colorScheme.surface,
                        elevation: theme.brightness == Brightness.dark ? 0 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ListenableBuilder(
                            listenable: _verseSyncCtrl,
                            builder: (context, _) {
                              final activeOrder =
                                  _verseSyncCtrl.activeVerseOrder;
                              return Column(
                                children: List.generate(_poemLines.length, (i) {
                                  final isActive =
                                      _verseSyncCtrl.hasSyncData &&
                                      activeOrder == i;
                                  final isFlashing =
                                      _flashingLineIndex == i; // ← اضافه کن
                                  return Padding(
                                    key: _lineKeys[i] ??=
                                        GlobalKey(), // ← key اینجا باشه
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Stack(
                                      children: [
                                        _PoemLineTile(
                                          text: _poemLines[i],
                                          isSelected: _selectedLineIndex == i,
                                          isHighlighted: _highlightedLineIndexes
                                              .contains(i),
                                          fontSize: _fontSize,
                                          lineHeight: _lineHeight,
                                          isFlashing: isFlashing, // ← اضافه
                                          fontFamily: _fontFamily,
                                          fontColor: _fontColor,
                                          onTap: () => setState(() {
                                            _selectedLineIndex =
                                                _selectedLineIndex == i
                                                ? null
                                                : i;
                                          }),
                                        ),
                                        // ── نشانگر مصراع فعال ──
                                        if (isActive) //edit
                                          Positioned(
                                            right: 4,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: AnimatedOpacity(
                                                opacity: isActive ? 1.0 : 0.0,
                                                duration: const Duration(
                                                  milliseconds: 0,
                                                ),
                                                child: Transform.flip(
                                                  flipX: true,
                                                  child: Icon(
                                                    Icons.arrow_back_rounded,
                                                    size: 20,
                                                    color: colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),

            // ── نوار اکشن ─────────────────────────────────────────
            Positioned(
              left: 28,
              right: 28,
              bottom: _args.hasAudio ? 190 : 30,
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

            // ── پلیر صدا ──────────────────────────────────────────
            if (_args.hasAudio)
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: AudioPlayerWidget(
                  id: _args.id,
                  audioUrl: _args.audioUrl,
                  fetchAudioUrl: _args.fetchAudioUrl,
                  controller: _audioCtrl,
                  title: _args.title,
                  verseSyncController: _verseSyncCtrl,
                  onRecitationChanged: (recitation) {
                    if (recitation.xmlText.isNotEmpty) {
                      _verseSyncCtrl.loadSyncPoints(
                        recitation.xmlText,
                      ); // ← به جای id
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── کاشی مصراع — دست نخورده نسبت به نسخه اصلی ────────────────────────────

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
    required this.isFlashing, // ← اضافه
  });

  final String text;
  final bool isSelected;
  final bool isHighlighted;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color fontColor;
  final VoidCallback onTap;
  final bool isFlashing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bg = Colors.transparent;
    Color border = Colors.transparent;
    Color textColor = colorScheme.onSurface;

    if (isFlashing) {
      bg = Colors.amber.withValues(alpha: 0.45);
      border = Colors.amber;
    } else if (isHighlighted) {
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
