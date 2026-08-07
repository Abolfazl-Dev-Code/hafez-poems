import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_local_service.dart';
import 'package:hafez_poems/poemsUnit/poems/poemScreenCacheService/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class FalActionButtons extends StatelessWidget {
  final FalLocalModel fal;
  final bool isSaved;
  final VoidCallback onRetry;
  final VoidCallback onSave;

  const FalActionButtons({
    super.key,
    required this.fal,
    required this.isSaved,
    required this.onRetry,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 24),
              label: const Text('فال مجدد', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
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
                onPressed: isSaved ? null : onSave,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    isSaved
                        ? Icons.check_rounded
                        : Icons.bookmark_border_rounded,
                    key: ValueKey(isSaved),
                  ),
                ),
                label: Text(isSaved ? 'ذخیره شد' : 'ذخیره'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSaved ? Colors.white : colorScheme.primary,
                  backgroundColor: isSaved
                      ? AppColors.success
                      : Colors.transparent,
                  side: BorderSide(
                    color: isSaved ? AppColors.success : colorScheme.outline,
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
              final ghazalId = (fal.id + 2129).toString();
              final ghazal = await GhazalLocalService.instance.fetchGhazalById(
                ghazalId,
              );
              if (!context.mounted) return;
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
                        Get.find<GhazalCacheService>().getAudioUrl(id),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
            ),
            child: const Icon(Icons.menu_book_rounded),
          ),
        ),
      ],
    );
  }
}
