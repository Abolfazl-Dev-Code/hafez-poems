import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_local_service.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_intention_card.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_result_card.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_action_buttons.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_loading_overlay.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/models/saved_item.dart';

class FalScreen extends StatefulWidget {
  const FalScreen({super.key});
  String get title => "فال حافظ";
  @override
  State<FalScreen> createState() => _FalScreenState();
}

class _FalScreenState extends State<FalScreen>
    with SingleTickerProviderStateMixin {
  static const _firstLoadDelay = Duration(milliseconds: 1800);
  static const _retryLoadDelay = Duration(milliseconds: 500);

  FalLocalModel? _currentFal;
  bool _isLoading = false;
  bool _isSaved = false;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _highlightController;
  late final Animation<double> _highlightAnimation;

  @override
  void initState() {
    super.initState();
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(milliseconds: 400),
    );
    _highlightAnimation = CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  void _triggerNewFalHighlight() {
    HapticFeedback.mediumImpact();
    _highlightController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _highlightController.reverse();
      }
    });
  }

  Future<void> _getNewFal() async {
    if (_isLoading) return;
    final bool isRetry = _currentFal != null;
    HapticFeedback.lightImpact();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }

    setState(() {
      _isLoading = true;
      _isSaved = false;
    });

    final delay = isRetry ? _retryLoadDelay : _firstLoadDelay;

    final results = await Future.wait([
      FalLocalService.instance.getRandomFal(),
      Future.delayed(delay),
    ]);

    if (!mounted) return;
    setState(() {
      _currentFal = results[0] as FalLocalModel;
      _isLoading = false;
    });
    if (isRetry) {
      _triggerNewFalHighlight();
    }
  }

  Future<void> _saveFal() async {
    if (_currentFal == null || _isSaved || _isLoading) return;
    HapticFeedback.lightImpact();
    final textToSave =
        '${_currentFal!.poem}\n\n📖 تفسیر:\n${_currentFal!.tabir}';
    final savedItem = SavedItem(
      poemId: 'fal_${_currentFal!.id}',
      category: 'fal',
      poemTitle: _currentFal!.title,
      poemText: textToSave,
      audioUrl: '',
    );
    await Get.find<IKeyedItemStorage<SavedItem>>().put(
      '${savedItem.poemId}|${savedItem.category}',
      savedItem,
    );
    if (!mounted) return;
    setState(() => _isSaved = true);
    AppSnackBarService.success(
      'فال ذخیره شد',
      duration: const Duration(milliseconds: 1800),
    );
  }

  Widget _buildFirstLoadButton(ThemeData theme) {
    return SizedBox(
      key: const ValueKey('button'),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _getNewFal,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.85,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'حافظ در حال انتخاب غزل است...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('normal'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 26,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'گرفتن فال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFalCard(ThemeData theme) {
    return Stack(
      key: ValueKey(_currentFal!.id),
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _highlightAnimation,
          builder: (context, child) {
            final glow = _highlightAnimation.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xxlRadius,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(
                        alpha: glow * 0.95,
                      ),
                      width: 2.8 * glow,
                    ),
                    boxShadow: glow > 0.05
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: glow * 0.40,
                              ),
                              blurRadius: 18 * glow,
                              spreadRadius: 1.5 * glow,
                            ),
                          ]
                        : null,
                  ),
                  child: child,
                ),
                if (glow > 0.25)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Opacity(
                      opacity: (glow - 0.25) / 0.75,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'جدید',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          child: FalResultCard(fal: _currentFal!),
        ),
        FalLoadingOverlay(isVisible: _isLoading),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool hasFal = _currentFal != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          toolbarHeight: 50,
          leading: Padding(
            padding: const EdgeInsets.only(top: 0.0, right: AppSpacing.xl),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Text(widget.title, style: textTheme.headlineMedium),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const FalIntentionCard(),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(curved),
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.88,
                          end: 1.0,
                        ).animate(curved),
                        child: child,
                      ),
                    ),
                  );
                },
                child: hasFal
                    ? _buildFalCard(theme)
                    : _buildFirstLoadButton(theme),
              ),
              const SizedBox(height: 28),
              if (hasFal)
                FalActionButtons(
                  fal: _currentFal!,
                  isSaved: _isSaved,
                  onRetry: _getNewFal,
                  onSave: _saveFal,
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
