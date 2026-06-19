import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';
import 'package:hafez_poems/widgets/persian_numbers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/controllers/user_actions_controller.dart';
import '../services/fal_local_service.dart';

class FalScreen extends StatefulWidget {
  const FalScreen({super.key});

  String get title => "فال حافظ";

  @override
  State<FalScreen> createState() => _FalScreenState();
}

class _FalScreenState extends State<FalScreen>
    with SingleTickerProviderStateMixin {
  FalLocalModel? _currentFal;
  bool _isLoading = false;
  bool _isSaved = false;

  late final AnimationController _snackProgressController;

  @override
  void initState() {
    super.initState();
    _snackProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _snackProgressController.dispose();
    super.dispose();
  }

  Future<void> _getNewFal() async {
    setState(() {
      _isLoading = true;
      _isSaved = false;
    });

    try {
      final fal = await FalLocalService.instance.getRandomFal();
      if (!mounted) return;
      setState(() => _currentFal = fal);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطا در دریافت فال')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSavedSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _snackProgressController
      ..reset()
      ..forward();

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      content: AnimatedBuilder(
        animation: _snackProgressController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1FA855),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.95),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'فال ذخیره شد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                  child: Stack(
                    children: [
                      Container(color: Colors.white.withValues(alpha: 0.22)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 1 - _snackProgressController.value,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _saveFal() async {
    if (_currentFal == null || _isSaved) return;

    final box = Hive.box<SavedItem>(UserActionsController.savedBoxName);

    final textToSave =
        '${_currentFal!.poem}\n\n📖 تفسیر:\n${_currentFal!.tabir}';

    final savedItem = SavedItem(
      id: 'fal_${_currentFal!.id}',
      title: _currentFal!.title,
      text: textToSave,
      audioUrl: '',
    );

    await box.add(savedItem);
    if (!mounted) return;
    setState(() => _isSaved = true);
    _showSavedSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
          toolbarHeight: 80,
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(top: 30.0, right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(widget.title, style: textTheme.headlineMedium),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'ابتدا نیت کنید:\n\n'
                    'ای حافظ شیرازی! تو محرم هر رازی!\n'
                    'تو را به خدا و به شاخ نباتت قسم می‌دهم\n'
                    'که هر چه صلاح و مصلحت می‌بینی برایم آشکار کن\n'
                    'و آرزوی مرا برآورده سازی.\n\n'
                    'برای شادی روح حافظ، صلوات یا فاتحه‌ای نثار نماییم.',
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      fontSize: 15.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: CircularProgressIndicator(),
                )
              else if (hasFal) ...[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // شماره فال
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'غزل ${_currentFal!.id}'.toPersianNumbers(),
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _currentFal!.poem,
                          style: textTheme.bodyLarge?.copyWith(
                            height: 2.0,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(height: 36),
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'تفسیر',
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.primary.withValues(
                                alpha: 0.18,
                              ),
                            ),
                          ),
                          child: Text(
                            _currentFal!.tabir,
                            style: textTheme.bodyLarge?.copyWith(
                              height: 1.9,
                              fontSize: 15.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _getNewFal,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 24),
                    label: const Text(
                      'گرفتن فال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              if (hasFal && !_isLoading)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _getNewFal,
                          icon: const Icon(Icons.refresh_rounded, size: 24),
                          label: const Text(
                            'فال مجدد',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          child: OutlinedButton.icon(
                            onPressed: _isSaved ? null : _saveFal,
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: Icon(
                                _isSaved
                                    ? Icons.check_rounded
                                    : Icons.bookmark_border_rounded,
                                key: ValueKey(_isSaved),
                              ),
                            ),
                            label: Text(_isSaved ? 'ذخیره شد' : 'ذخیره'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isSaved
                                  ? Colors.white
                                  : colorScheme.primary,
                              backgroundColor: _isSaved
                                  ? const Color(0xFF1FA855)
                                  : Colors.transparent,
                              side: BorderSide(
                                color: _isSaved
                                    ? const Color(0xFF1FA855)
                                    : colorScheme.outline,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: OutlinedButton(
                        onPressed: () async {
                          final ghazalId = (_currentFal!.id + 2129).toString();
                          final ghazal = await GhazalLocalService.instance
                              .fetchGhazalById(ghazalId);
                          if (!mounted) return;
                          Get.to(
                            () => PoemScreen(
                              args: PoemScreenArgs(
                                id: ghazal.id,
                                title: ghazal.title,
                                text: ghazal.text,
                                fetchText: (id) => GhazalLocalService.instance
                                    .fetchGhazalById(id)
                                    .then((g) => g.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<GhazalCacheService>().getAudioUrl(
                                      id,
                                    ),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.menu_book_rounded),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
