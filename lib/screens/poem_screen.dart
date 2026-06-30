// lib/screens/poem_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/controllers/audio_player_controller.dart';
import 'package:hafez_poems/controllers/profile_controller.dart';
import 'package:hafez_poems/controllers/verse_sync_controller.dart';
import 'package:hafez_poems/services/app_snackbar_service.dart';
import 'package:hafez_poems/widgets/active_verse_indicator_widget.dart';
import 'package:hafez_poems/widgets/audio_player_widget.dart';
import 'package:hafez_poems/widgets/ghazal_action_bar.dart';
import 'package:hafez_poems/widgets/poem_selected_text.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/user_actions_controller.dart';

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
  int? _lastAutoScrolledVerseOrder;
  bool _userIsInteractingWithScroll = false;
  Timer? _resumeAutoScrollTimer;
  final ScrollController _scrollController = ScrollController();
  static const String _fontSizeKey = 'reading_font_size';
  static const String _lineHeightKey = 'reading_line_height';
  static const String _fontFamilyKey = 'reading_font_family';
  static const String _fontColorKey = 'reading_font_color';
  // ← اضافه: برای اندازه‌گیری واقعی ارتفاع نوار پایین
  final GlobalKey _bottomOverlayKey = GlobalKey();
  bool _isAudioExpanded = false;
  double? _collapsedOverlayHeight;
  double? _expandedOverlayHeight;
  // ← اضافه: حداقل زمان حضور در صفحه برای ثبت «خوانده‌شده»
  static const Duration _minReadDuration = Duration(seconds: 9);
  Timer? _markAsReadTimer;

  double _fontSize = 20;
  double _lineHeight = 1.9;
  String _fontFamily = 'Vazir';
  Color _fontColor = Colors.black;

  final UserActionsController _actionController = UserActionsController();
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
    _verseSyncCtrl.addListener(_onActiveVerseChanged); // ← اضافه
    _loadReadingSettings();
    _loadInitialActionsState();
    _scheduleMarkAsRead(); // ← قبلاً: _markAsRead();
    _initText();
    _scheduleMeasureBottomOverlay(); // ← اضافه
  }

  void _syncPosition() {
    debugPrint(
      '🎵 position: ${_audioCtrl.position}, hasSyncData: ${_verseSyncCtrl.hasSyncData}, activeOrder: ${_verseSyncCtrl.activeVerseOrder}',
    );
    _verseSyncCtrl.updatePosition(_audioCtrl.position);
  }

  // ── اسکرول خودکار بر اساس خطِ سینک‌شده ─────────────

  void _onActiveVerseChanged() {
    if (_userIsInteractingWithScroll) return;

    final order = _verseSyncCtrl.activeVerseOrder;
    if (order < 0) return;
    if (order == _lastAutoScrolledVerseOrder) return;

    _lastAutoScrolledVerseOrder = order;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLineIndex(order);
    });
  }

  /// اسکرول نرم به خطِ مشخص‌شده، با لنگرگاهِ تقریباً یک‌سومِ بالای صفحه
  Future<void> _scrollToLineIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 450),
    double anchorFraction = 1 / 3,
  }) async {
    if (!mounted) return;

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
      // اجازه بده با موقعیت فعلیِ پخش دوباره سینک شه
      _lastAutoScrolledVerseOrder = null;
      _onActiveVerseChanged();
    });
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

    final buffer = StringBuffer();
    buffer.writeln('📜 ${_args.title}');
    buffer.writeln();
    buffer.writeln(_poemText.trim());
    buffer.writeln();
    buffer.writeln('—');
    buffer.writeln('اشعار حافظ - دیوان');
    buffer.writeln(
      'https://github.com/Abolfazl-Dev-Code/hafez-poems/releases/',
    );

    SharePlus.instance.share(ShareParams(text: buffer.toString()));
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
    _isLiked = _actionController.isLiked(_args.id);
    _isSaved = _actionController.isSaved(_args.id);
    _highlightedLineIndexes.addAll(
      _actionController.getHighlightedLineIndexes(_args.id),
    );
  }

  /// تایمرِ حداقل زمان حضور را شروع می‌کند. اگر کاربر زودتر از
  /// [_minReadDuration] از صفحه خارج شود، `dispose()` این تایمر را
  /// کنسل می‌کند و `_markAsRead` هیچ‌وقت اجرا نمی‌شود.
  void _scheduleMarkAsRead() {
    _markAsReadTimer = Timer(_minReadDuration, () {
      if (!mounted) return;
      _markAsRead();
    });
  }

  void _markAsRead() {
    final box = Hive.box(ProfileController.readBoxName);
    // جلوگیری از نوشتنِ تکراری اگه از قبل خوانده‌شده بوده
    if (box.get(_args.id) != true) {
      box.put(_args.id, true);
    }
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

  Future<void> _copyLine(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    AppSnackBarService.success(context, 'مصرع کپی شد');
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
    _markAsReadTimer?.cancel(); // ← اضافه
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
    const double breathingRoom = 16; // فاصله‌ی نفس بین متن شعر و نوار اکشن
    final double bottomInset = _args.hasAudio
        ? 10
        : 110; // همون bottom پایین Positioned
    final double overlayHeight = !_args.hasAudio
        ? 0
        : (_isAudioExpanded
                  ? _expandedOverlayHeight
                  : _collapsedOverlayHeight) ??
              150; // تخمین اولیه تا قبل از اولین اندازه‌گیری
    final double bottomPadding =
        (_args.hasAudio ? overlayHeight + bottomInset : 110) + breathingRoom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 45, // پیش‌فرض 56 هست، می‌تونی هر عددی که خواستی بگذاری
          title: Text(_args.title, style: textTheme.headlineMedium),
          leading: Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: IconButton(
              iconSize: 25,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
                if (_args.hasAudio) _audioCtrl.stop();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: IconButton(
                icon: const Icon(Icons.share_rounded),
                iconSize: 21,
                onPressed: _isTextLoading ? null : _sharePoem,
                tooltip: 'اشتراک‌گذاری',
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
                            padding: const EdgeInsets.all(16),
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

                                    final verseText = PoemSelectedText(
                                      text: _poemLines[i],
                                      isSelected: _selectedLineIndex == i,
                                      isHighlighted: _highlightedLineIndexes
                                          .contains(i),
                                      fontSize: _fontSize,
                                      lineHeight: _lineHeight,
                                      isFlashing: isFlashing,
                                      fontFamily: _fontFamily,
                                      fontColor: _fontColor,
                                      onTap: () => setState(() {
                                        _selectedLineIndex =
                                            _selectedLineIndex == i ? null : i;
                                      }),
                                      onLongPress: () =>
                                          _copyLine(_poemLines[i]),
                                    );
                                    // space between indicator and text
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
                                                  width: 20,
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
            // ── نوار اکشن + پلیر صدا (دقیقاً زیر هم، فاصله ۵ پیکسل) ──
            Positioned(
              left: 12,
              right: 12,
              bottom: _args.hasAudio ? 10 : 100,
              child: Column(
                key: _bottomOverlayKey, // ← اضافه
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
                      id: _args.id,
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
                        // ← اضافه
                        setState(() => _isAudioExpanded = expanded);
                        // صبر تا انیمیشن AnimatedSize پلیر (۲۲۰ms) کامل شود، بعد اندازه واقعی گرفته شود
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
