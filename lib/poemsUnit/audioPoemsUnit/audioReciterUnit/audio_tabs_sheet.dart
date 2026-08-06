import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_manager.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/downloads_list_tab.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/audio_tabs_bar.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_list_tile.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';

class AudioTabsSheet extends StatefulWidget {
  final List<RecitationInfo> recitations;
  final RecitationInfo? selected;
  final ThemeData theme;
  final ColorScheme cs;
  final String poemId;
  final String category;
  final String poemTitle;
  final AudioPlayerController ctrl;
  final VerseSyncController? verseSyncController;
  final void Function(RecitationInfo) onSelect;

  const AudioTabsSheet({
    super.key,
    required this.recitations,
    required this.selected,
    required this.theme,
    required this.cs,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.ctrl,
    this.verseSyncController,
    required this.onSelect,
  });

  @override
  State<AudioTabsSheet> createState() => _AudioTabsSheetState();
}

class _AudioTabsSheetState extends State<AudioTabsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchCtrl;
  late List<RecitationInfo> _filtered;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _searchCtrl = TextEditingController();
    _filtered = _sortedList(widget.recitations);

    Get.find<AudioDownloadManager>().onError = (msg) {
      if (mounted) {
        AppSnackBarService.error(msg, duration: const Duration(seconds: 3));
      }
    };
  }

  List<RecitationInfo> _sortedList(List<RecitationInfo> list) {
    final sorted = List<RecitationInfo>.from(list);
    sorted.sort((a, b) => a.audioArtist.compareTo(b.audioArtist));
    return sorted;
  }

  void _onSearch(String query) {
    final q = query.trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = _sortedList(widget.recitations);
      } else {
        _filtered = _sortedList(
          widget.recitations.where((r) => r.audioArtist.contains(q)).toList(),
        );
      }
    });
  }

  @override
  void dispose() {
    Get.find<AudioDownloadManager>().onError = null;
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    final theme = widget.theme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppRadius.xlRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.15),
                  borderRadius: AppRadius.xsRadius,
                ),
              ),
            ),
            AudioTabsBar(tabController: _tabController, cs: cs),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecitersTab(theme, cs),
                  DownloadsListTab(
                    poemId: widget.poemId,
                    category: widget.category,
                    poemTitle: widget.poemTitle,
                    ctrl: widget.ctrl,
                    verseSyncController: widget.verseSyncController,
                    theme: theme,
                    cs: cs,
                  ),
                ],
              ),
            ),
            SizedBox(height: bottomPadding + 12),
          ],
        ),
      ),
    );
  }

  Widget _buildRecitersTab(ThemeData theme, ColorScheme cs) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearch,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
            decoration: InputDecoration(
              hintText: 'جستجو بر اساس نام...',
              hintTextDirection: TextDirection.rtl,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: AppRadius.mdRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 32,
                        color: cs.onSurface.withValues(alpha: 0.25),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'خواننده‌ای یافت نشد',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final r = _filtered[index];
                    final isSelected = r == widget.selected;

                    return ReciterListTile(
                      recitation: r,
                      isSelected: isSelected,
                      theme: theme,
                      cs: cs,
                      poemId: widget.poemId,
                      category: widget.category,
                      poemTitle: widget.poemTitle,
                      ctrl: widget.ctrl,
                      onSelect: widget.onSelect,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
