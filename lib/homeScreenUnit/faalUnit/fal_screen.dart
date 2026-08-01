import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_local_service.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';
import 'package:hafez_poems/models/saved_item.dart';

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

  Future<void> _saveFal() async {
    if (_currentFal == null || _isSaved) return;

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
          toolbarHeight: 50,
          leading: Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 22.0),
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'ابتدا نیت کنید:\n'
                    'ای حافظ شیرازی! تو محرم هر رازی!\n'
                    'تو را به خدا و به شاخ نباتت قسم می‌دهم\n'
                    'که هر چه صلاح و مصلحت می‌بینی\n برایم آشکار کن\n'
                    'و آرزوی مرا برآورده سازی.',
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      fontSize: 17.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: CircularProgressIndicator(),
                )
              else if (hasFal) ...[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.xxlRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: AppRadius.smRadius,
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
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.06),
                            borderRadius: AppRadius.mdRadius,
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
                        borderRadius: AppRadius.lgRadius,
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
                              borderRadius: AppRadius.lgRadius,
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
                                  ? AppColors.success
                                  : Colors.transparent,
                              side: BorderSide(
                                color: _isSaved
                                    ? AppColors.success
                                    : colorScheme.outline,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgRadius,
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
                                category: 'ghazal',
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
                            borderRadius: AppRadius.lgRadius,
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
