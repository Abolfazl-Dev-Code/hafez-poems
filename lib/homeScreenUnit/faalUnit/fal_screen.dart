import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_local_service.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_intention_card.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_result_card.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_action_buttons.dart';
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const FalIntentionCard(),
              const SizedBox(height: 24),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: CircularProgressIndicator(),
                )
              else if (hasFal) ...[
                FalResultCard(fal: _currentFal!),
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
                FalActionButtons(
                  fal: _currentFal!,
                  isSaved: _isSaved,
                  onRetry: _getNewFal,
                  onSave: _saveFal,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
