import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_widget.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_line_context_menu.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poemsActionBarUnit/poem_action_bar.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_selected_text.dart';
import 'package:hafez_poems/poemsUnit/verseShareUnit/verse_share_sheet.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/active_verse_indicator_widget.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_read_status_storage.dart';

class PoemScreenArgs {
  final String id;
  final String category;
  final String title;
  final String text;
  final String audioUrl;
  final Future<String> Function(String id) fetchText;
  final Future<String> Function(String id)? fetchAudioUrl;
  final int? highlightLineIndex;

  const PoemScreenArgs({
    required this.id,
    required this.category,
    required this.title,
    required this.text,
    required this.fetchText,
    this.audioUrl = '',
    this.fetchAudioUrl,
    this.highlightLineIndex,
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

  double _fontSize = 20;
  double _lineHeight = 1.9;
  String _fontFamily = 'Vazir';
  Color _fontColor = Colors.black;

  final UserActionsSaver _actionController = UserActionsSaver();
  bool _isLiked = false;
  bool _isSaved = false;
  int? _selectedLineIndex;
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

  bool get _isSelectedLineHighlighted =>
      _selectedLineIndex != null &&
      _highlightedLineIndexes.contains(_selectedLineIndex);

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
  }

  void _syncPosition() {
    if (!_audioCtrl.isPlaying) return;

    _verseSyncCtrl.updatePosition(_audioCtrl.position);
  }

  void _onActiveVerseChanged() {
    // Re-apply position when sync data finishes loading during playback.
    if (_audioCtrl.isPlaying && _verseSyncCtrl.hasSyncData) {
      _verseSyncCtrl.updatePosition(_audioCtrl.position);
    }

    // فقط هنگام پخش
    if (!_audioCtrl.isPlaying) return;

    if (_userIsInteractingWithScroll) return;
    if (_isContextMenuOpen) return;

    final order = _verseSyncCtrl.activeVerseOrder;

    if (order < 0) return;
    if (order == _lastAutoScrolledVerseOrder) return;

    _lastAutoScrolledVerseOrder = order;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLineIndex(order);
    });
  }

  Future<void> _scrollToLineIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 450),
    double anchorFraction = 1 / 3,
  }) async {
    if (!mounted) return;
    if (_isContextMenuOpen) return;
    final key = _lineKeys[index];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !_scrollController.hasClients) return;

    final scrollBox =
        _scrollController.position.context.storageContext.findRenderObject()
            as RenderBox?;
    if (scrollBox == null || !scrollBox.attached) return;

    final tileOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
    final screenHeight = scrollBox.size.height;
    final targetOffset =
        (_scrollController.offset +
                tileOffset.dy -
                screenHeight * anchorFraction)
            .clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      targetOffset,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  void _pauseAutoScroll() {
    _resumeAutoScrollTimer?.cancel();
    _userIsInteractingWithScroll = true;
  }

  void _scheduleResumeAutoScroll() {
    _resumeAutoScrollTimer?.cancel();
    _resumeAutoScrollTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      _userIsInteractingWithScroll = false;
      _lastAutoScrolledVerseOrder = null;
      _onActiveVerseChanged();
    });
  }

  void _resumeAutoScrollImmediately() {
    _resumeAutoScrollTimer?.cancel();
    if (!mounted) return;
    _userIsInteractingWithScroll = false;
    _lastAutoScrolledVerseOrder = null;
    _onActiveVerseChanged();
  }

  void _measureBottomOverlay() {
    if (!mounted) return;
    final box =
        _bottomOverlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final height = box.size.height;
    setState(() {
      if (_isAudioExpanded) {
        _expandedOverlayHeight = height;
      } else {
        _collapsedOverlayHeight = height;
      }
    });
  }

  void _scheduleMeasureBottomOverlay({Duration delay = Duration.zero}) {
    Future.delayed(delay, () {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _measureBottomOverlay(),
      );
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

  Future<void> _showLineMenu(int index, LongPressStartDetails details) async {
    if (_contextMenuController.isOpen) return;

    final renderObject = _verseTargetKeys[index]?.currentContext
        ?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final targetSize = renderObject.size;
    final targetOffset = renderObject.localToGlobal(Offset.zero);

    HapticFeedback.mediumImpact();
    _pauseAutoScroll();
    setState(() {
      _selectedLineIndex = index;
      _menuOpenLineIndex = index;
    });

    final layerLink = _lineLayerLinks[index] ??= LayerLink();

    _contextMenuController.show(
      context: context,
      layerLink: layerLink,
      targetSize: targetSize,
      targetOffset: targetOffset,
      isHighlighted: _highlightedLineIndexes.contains(index),
      lineBuilder: (ctx) => PoemSelectedText(
        text: _poemLines[index],
        isSelected: _selectedShareLines.contains(index),
        isHighlighted: _highlightedLineIndexes.contains(index),
        fontSize: _fontSize,
        lineHeight: _lineHeight,
        fontFamily: _fontFamily,
        fontColor: _fontColor,
        isFlashing: false,
        onTap: () {},
      ),
      onCopy: () => _copyLine(_poemLines[index]),
      onToggleHighlight: () {
        _selectedLineIndex = index;
        _toggleHighlight();
      },
      onShareAsImage: () => _showShareModeSheet(index),
      onClosed: () {
        if (!mounted) return;
        setState(() {
          _menuOpenLineIndex = null;
          _selectedLineIndex = null;
        });
        _resumeAutoScrollImmediately();
      },
      onPlayFromHere: () => _playFromVerse(index),
    );
  }

  Future<void> _playFromVerse(int verseOrder) async {
    final player = _audioWidgetKey.currentState;
    if (player == null) return;

    final loadingTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      AppSnackBarService.info('درحال بارگیری صدا، لطفاً منتظر بمانید.');
    });

    try {
      await player.prepareForPlay();
    } finally {
      loadingTimer.cancel();
    }

    if (!mounted) return;

    const manualOffset = Duration(milliseconds: 200);

    final position = _verseSyncCtrl.positionForVerse(verseOrder);

    if (position == null) {
      AppSnackBarService.error('موقعیت این مصرع پیدا نشد.');
      return;
    }

    final playPosition = position > manualOffset
        ? position - manualOffset
        : Duration.zero;

    await player.playFromPosition(playPosition);
  }

  void _startMultiLineSelection(int index) {
    setState(() {
      _isMultiLineSelecting = true;
      _selectedShareLines
        ..clear()
        ..add(index);
    });
  }

  void _showShareModeSheet(int index) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اشتراک‌گذاری مصرع',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'انتخاب کنید فقط همین مصرع یا چند مصرع را به اشتراک بگذارید.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pop(context);

                    showVerseShareSheet(
                      context,
                      verseText: _poemLines[index],
                      poemTitle: _args.title,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: .12,
                          ),
                          child: Icon(
                            Icons.text_fields_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'همین مصرع',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'اشتراک‌گذاری فقط همین مصرع',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.chevron_left_rounded,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  height: 20,
                  color: theme.dividerColor.withValues(alpha: .5),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pop(context);
                    _startMultiLineSelection(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: .12,
                          ),
                          child: Icon(
                            Icons.library_books_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'انتخاب چند مصرع',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ادامه انتخاب و اشتراک چند مصرع',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.chevron_left_rounded,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleShareLineSelection(int index) {
    setState(() {
      if (_selectedShareLines.contains(index)) {
        _selectedShareLines.remove(index);
      } else {
        _selectedShareLines.add(index);
      }
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
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      await _scrollToLineIndex(
        targetIndex,
        duration: const Duration(milliseconds: 500),
      );

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
    _isLiked = _actionController.isLiked(_args.id, _args.category);
    _isSaved = _actionController.isSaved(_args.id, _args.category);
    _highlightedLineIndexes.addAll(
      _actionController.getHighlightedLineIndexes(_args.id, _args.category),
    );
  }

  void _scheduleMarkAsRead() {
    _markAsReadTimer = Timer(_minReadDuration, () {
      if (!mounted) return;
      _markAsRead();
    });
  }

  void _markAsRead() {
    Get.find<IReadStatusStorage>().markAsRead(_args.id);
  }

  Future<void> _toggleLike() async {
    await _actionController.toggleLike(
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      setState(
        () => _isLiked = _actionController.isLiked(_args.id, _args.category),
      );
    }
  }

  Future<void> _toggleSave() async {
    await _actionController.toggleSave(
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      setState(
        () => _isSaved = _actionController.isSaved(_args.id, _args.category),
      );
    }
  }

  Future<void> _copyLine(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    AppSnackBarService.success('مصرع کپی شد');
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
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
      highlightedLine: lineText,
      lineIndex: index,
      color: const Color(0xFFFFC107),
    );

    if (!mounted) return;
    setState(() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    const double breathingRoom = 16;
    final double bottomInset = _args.hasAudio ? 10 : 110;
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
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          leadingWidth: 65,
          leading: _isMultiLineSelecting
              ? null
              : IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (_args.hasAudio) _audioCtrl.stop();
                  },
                ),
          titleSpacing: 35,
          title: _isMultiLineSelecting
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_selectedShareLines.length} مصرع انتخاب شده'
                        .toPersianNumbers(),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Text(_args.title, style: textTheme.headlineMedium),

          actions: _isMultiLineSelecting
              ? [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isMultiLineSelecting = false;
                              _selectedShareLines.clear();
                            });
                          },
                          child: const Text('لغو'),
                        ),
                        TextButton(
                          onPressed: _selectedShareLines.isEmpty
                              ? null
                              : () {
                                  final indexes = _selectedShareLines.toList()
                                    ..sort();

                                  final text = indexes
                                      .map((i) => _poemLines[i])
                                      .join('\n');

                                  setState(() {
                                    _isMultiLineSelecting = false;
                                    _selectedShareLines.clear();
                                  });

                                  showVerseShareSheet(
                                    context,
                                    verseText: text,
                                    poemTitle: _args.title,
                                  );
                                },
                          child: const Text('تایید'),
                        ),
                      ],
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded),
                      iconSize: 21,
                      onPressed: _isTextLoading ? null : _sharePoem,
                    ),
                  ),
                ],
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
                        padding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding),
                        child: Card(
                          color: colorScheme.surface,
                          elevation: theme.brightness == Brightness.dark
                              ? 0
                              : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: theme.dividerColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: ListenableBuilder(
                              listenable: _verseSyncCtrl,
                              builder: (context, _) {
                                final activeOrder =
                                    _verseSyncCtrl.activeVerseOrder;
                                return Column(
                                  children: List.generate(_poemLines.length, (
                                    i,
                                  ) {
                                    final isActive =
                                        _verseSyncCtrl.hasSyncData &&
                                        activeOrder == i;
                                    final isFlashing = _flashingLineIndex == i;

                                    final layerLink = _lineLayerLinks[i] ??=
                                        LayerLink();
                                    final verseKey = _verseTargetKeys[i] ??=
                                        GlobalKey();

                                    final verseText = CompositedTransformTarget(
                                      link: layerLink,
                                      child: KeyedSubtree(
                                        key: verseKey,
                                        child: Opacity(
                                          opacity: _menuOpenLineIndex == i
                                              ? 0
                                              : 1,
                                          child: PoemSelectedText(
                                            text: _poemLines[i],
                                            isSelected: _isMultiLineSelecting
                                                ? _selectedShareLines.contains(
                                                    i,
                                                  )
                                                : _selectedLineIndex == i,
                                            isHighlighted:
                                                _highlightedLineIndexes
                                                    .contains(i),
                                            fontSize: _fontSize,
                                            lineHeight: _lineHeight,
                                            isFlashing: isFlashing,
                                            fontFamily: _fontFamily,
                                            fontColor: _fontColor,
                                            onTap: () {
                                              if (_isMultiLineSelecting) {
                                                _toggleShareLineSelection(i);
                                                return;
                                              }

                                              setState(() {
                                                _selectedLineIndex =
                                                    _selectedLineIndex == i
                                                    ? null
                                                    : i;
                                              });
                                            },
                                            onLongPress: (details) =>
                                                _showLineMenu(i, details),
                                          ),
                                        ),
                                      ),
                                    );
                                    return Padding(
                                      key: _lineKeys[i] ??= GlobalKey(),
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        right: 0,
                                      ),
                                      child: _verseSyncCtrl.hasSyncData
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: indicatorSlotSize,
                                                  height: indicatorSlotSize,
                                                  child: Center(
                                                    child: AnimatedSwitcher(
                                                      duration: const Duration(
                                                        milliseconds: 250,
                                                      ),
                                                      transitionBuilder:
                                                          (
                                                            child,
                                                            anim,
                                                          ) => ScaleTransition(
                                                            scale: anim,
                                                            child:
                                                                FadeTransition(
                                                                  opacity: anim,
                                                                  child: child,
                                                                ),
                                                          ),
                                                      child: isActive
                                                          ? ActiveVerseIndicator(
                                                              key: const ValueKey(
                                                                'active_indicator',
                                                              ),
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                            )
                                                          : const SizedBox.shrink(
                                                              key: ValueKey(
                                                                'inactive_indicator',
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 6.5),
                                                Expanded(child: verseText),
                                              ],
                                            )
                                          : verseText,
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: _args.hasAudio ? 10 : 100,
              child: Column(
                key: _bottomOverlayKey,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PoemActionBar(
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
                  if (_args.hasAudio) const SizedBox(height: 5),
                  if (_args.hasAudio)
                    AudioPlayerWidget(
                      key: _audioWidgetKey,
                      id: _args.id,
                      category: _args.category,
                      audioUrl: _args.audioUrl,
                      fetchAudioUrl: _args.fetchAudioUrl,
                      controller: _audioCtrl,
                      title: _args.title,
                      verseSyncController: _verseSyncCtrl,
                      onRecitationChanged: (recitation) {
                        if (recitation.xmlText.isNotEmpty) {
                          _verseSyncCtrl.loadSyncPoints(recitation.xmlText);
                        }
                      },
                      onExpansionChanged: (expanded) {
                        setState(() => _isAudioExpanded = expanded);
                        _scheduleMeasureBottomOverlay(
                          delay: const Duration(milliseconds: 260),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
