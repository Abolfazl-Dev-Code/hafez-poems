import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/poems/poemScreenAppbar/app_bar_more_menu.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_widget.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_line_context_menu.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_selected_text.dart';
import 'package:hafez_poems/poemsUnit/verseShareUnit/verse_share_sheet.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/active_verse_indicator_widget.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_read_status_storage.dart';
import 'share_mode_option_tile.dart';
export 'poem_screen_args.dart';
import 'poem_screen_args.dart';
part 'poem_screen_scroll.dart';
part '../poemContextMenuUnit/poem_screen_line_menu.dart';
part 'poem_screen_actions.dart';
part 'poem_read_marker.dart';
part 'poemScreenAppbar/poem_screen_app_bar_builder.dart';
part 'poem_screen_card_builder.dart';

class PoemScreen extends StatefulWidget {
  final PoemScreenArgs args;
  const PoemScreen({super.key, required this.args});
  @override
  State<PoemScreen> createState() => _PoemScreenState();
}

class _PoemScreenState extends State<PoemScreen>
    with SingleTickerProviderStateMixin {
  late final AudioPlayerController _audioCtrl = AudioPlayerController();
  late final VerseSyncController _verseSyncCtrl = VerseSyncController();
  final GlobalKey<AudioPlayerWidgetState> _audioWidgetKey =
      GlobalKey<AudioPlayerWidgetState>();
  final Map<int, GlobalKey> _lineKeys = {};
  final Map<int, LayerLink> _lineLayerLinks = {};
  final Map<int, GlobalKey> _verseTargetKeys = {};
  final PoemLineContextMenuController _contextMenuController =
      PoemLineContextMenuController();
  int? _menuOpenLineIndex;
  bool get _isContextMenuOpen => _menuOpenLineIndex != null;
  int? _flashingLineIndex;
  String _poemText = '';
  bool _isTextLoading = true;
  String _textError = '';
  int? _lastAutoScrolledVerseOrder;
  bool _userIsInteractingWithScroll = false;
  Timer? _resumeAutoScrollTimer;
  final ScrollController _scrollController = ScrollController();
  static const String _fontSizeKey = 'reading_font_size';
  static const String _lineHeightKey = 'reading_line_height';
  static const String _fontFamilyKey = 'reading_font_family';
  static const String _fontColorKey = 'reading_font_color';
  final GlobalKey _bottomOverlayKey = GlobalKey();
  bool _isAudioExpanded = false;
  double? _collapsedOverlayHeight;
  double? _expandedOverlayHeight;
  static const Duration _minReadDuration = Duration(seconds: 9);
  Timer? _markAsReadTimer;
  static const double indicatorSlotSize = 18.0;
  late final AnimationController _shareController;
  double _fontSize = 20;
  double _lineHeight = 1.9;
  String _fontFamily = 'Vazir';
  Color _fontColor = Colors.black;
  final UserActionsSaver _actionController = UserActionsSaver();
  final ValueNotifier<bool> _isLiked = ValueNotifier(false);
  final ValueNotifier<bool> _isSaved = ValueNotifier(false);
  int? _selectedLineIndex;
  int? _readUpToLineIndex;
  final Set<int> _highlightedLineIndexes = {};
  bool _isMultiLineSelecting = false;
  final Set<int> _selectedShareLines = {};
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

  @override
  void initState() {
    super.initState();
    _audioCtrl.addListener(_syncPosition);
    _verseSyncCtrl.addListener(_onActiveVerseChanged);
    _loadReadingSettings();
    _loadInitialActionsState();
    _scheduleMarkAsRead();
    _initText();
    _scheduleMeasureBottomOverlay();
    _loadReadProgress();
    _shareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _loadReadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('progress_poem_${_args.id}');

    if (savedIndex != null && savedIndex != -1) {
      setState(() {
        _readUpToLineIndex = savedIndex;
      });
    }
  }

  Future<void> toggleReadUpToHere(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readUpToLineIndex = _readUpToLineIndex == index ? null : index;
    });
    await prefs.setInt('progress_poem_${_args.id}', _readUpToLineIndex ?? -1);
  }

  void _updateOverlayHeight(double height) {
    setState(() {
      if (_isAudioExpanded) {
        _expandedOverlayHeight = height;
      } else {
        _collapsedOverlayHeight = height;
      }
    });
  }

  void _toggleSelectedLineIndex(int index) {
    setState(() {
      _selectedLineIndex = _selectedLineIndex == index ? null : index;
    });
  }

  void _exitMultiLineSelection() {
    setState(() {
      _isMultiLineSelecting = false;
      _selectedShareLines.clear();
    });
  }

  void _setAudioExpanded(bool expanded) {
    setState(() => _isAudioExpanded = expanded);
  }

  void _setTextLoadingState({required bool isLoading, String error = ''}) {
    setState(() {
      _isTextLoading = isLoading;
      _textError = error;
    });
  }

  void _setPoemText(String text) {
    setState(() {
      _poemText = text;
      _isTextLoading = false;
    });
  }

  void _setFlashingLineIndex(int? index) {
    setState(() => _flashingLineIndex = index);
  }

  void _setIsLiked(bool value) {
    _isLiked.value = value;
  }

  void _setIsSaved(bool value) {
    _isSaved.value = value;
  }

  void _updateHighlightedLines() {
    setState(() {
      if (_selectedLineIndex == null) return;
      final index = _selectedLineIndex!;
      if (_actionController.isLineHighlighted(
        _args.id,
        _args.category,
        index,
      )) {
        _highlightedLineIndexes.add(index);
      } else {
        _highlightedLineIndexes.remove(index);
      }
    });
  }

  void _setLineMenuState({int? selectedLineIndex, int? menuOpenLineIndex}) {
    setState(() {
      if (selectedLineIndex != null || selectedLineIndex == null) {
        _selectedLineIndex = selectedLineIndex;
      }
      if (menuOpenLineIndex != null || menuOpenLineIndex == null) {
        _menuOpenLineIndex = menuOpenLineIndex;
      }
    });
  }

  void _setMultiLineSelection(int index) {
    setState(() {
      _isMultiLineSelecting = true;
      _selectedShareLines
        ..clear()
        ..add(index);
    });
  }

  void _toggleShareLine(int index) {
    setState(() {
      if (_selectedShareLines.contains(index)) {
        _selectedShareLines.remove(index);
      } else {
        _selectedShareLines.add(index);
      }
    });
  }

  void _sharePoem() {
    if (_isTextLoading || _poemText.isEmpty) return;
    showVerseShareSheet(context, verseText: _poemText, poemTitle: _args.title);
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

  @override
  void dispose() {
    _contextMenuController.dispose();
    _markAsReadTimer?.cancel();
    _resumeAutoScrollTimer?.cancel();
    _verseSyncCtrl.removeListener(_onActiveVerseChanged);
    _scrollController.dispose();
    _audioCtrl.removeListener(_syncPosition);
    _audioCtrl.dispose();
    _verseSyncCtrl.dispose();
    _shareController.dispose();
    _isLiked.dispose();
    _isSaved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    const double breathingRoom = 16;
    final double bottomInset = _args.hasAudio ? 10 : 16;
    final double overlayHeight = !_args.hasAudio
        ? 0
        : (_isAudioExpanded
                  ? _expandedOverlayHeight
                  : _collapsedOverlayHeight) ??
              150;
    final double bottomPadding =
        (_args.hasAudio ? overlayHeight + bottomInset : 110) + breathingRoom;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme, colorScheme, textTheme),
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
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification &&
                            notification.dragDetails != null) {
                          _pauseAutoScroll();
                        } else if (notification is ScrollEndNotification) {
                          _scheduleResumeAutoScroll();
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: _isContextMenuOpen
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(12, 10, 12, bottomPadding),
                        child: _buildPoemLinesCard(
                          theme,
                          colorScheme,
                          textTheme,
                        ),
                      ),
                    ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: _args.hasAudio ? 10 : 100,
              child: _buildBottomOverlay(),
            ),
          ],
        ),
      ),
    );
  }
}
