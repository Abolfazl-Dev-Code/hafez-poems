import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_manager.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/downloads_list_tab.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_download_control.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/set_default_reciter.dart';
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
            AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, child) {
                final animationValue = _tabController.animation!.value;

                return Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(1 - (animationValue * 2), 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 38,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.12),
                            borderRadius: AppRadius.mdRadius,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _tabController.animateTo(0);
                              },
                              child: Center(
                                child: Text(
                                  'خوانندگان',
                                  style: TextStyle(
                                    color: animationValue < 0.5
                                        ? cs.primary
                                        : cs.onSurface.withValues(alpha: 0.5),
                                    fontWeight: animationValue < 0.5
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _tabController.animateTo(1);
                              },
                              child: Center(
                                child: Text(
                                  'دانلودها',
                                  style: TextStyle(
                                    color: animationValue > 0.5
                                        ? cs.primary
                                        : cs.onSurface.withValues(alpha: 0.5),
                                    fontWeight: animationValue > 0.5
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
                    final initial = r.audioArtist.isNotEmpty
                        ? r.audioArtist.characters.first
                        : '؟';
                    final reciterKey = ReciterKey.from(r.audioArtist);

                    return InkWell(
                      onTap: () {
                        widget.onSelect(r);
                        Navigator.pop(context);
                      },
                      borderRadius: AppRadius.mdRadius,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                          borderRadius: AppRadius.mdRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? cs.primary.withValues(alpha: 0.15)
                                    : cs.onSurface.withValues(alpha: 0.07),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? cs.primary
                                      : cs.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.audioArtist,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected ? cs.primary : cs.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 14),
                            ReciterDownloadControl(
                              poemId: widget.poemId,
                              category: widget.category,
                              poemTitle: widget.poemTitle,
                              reciterKey: reciterKey,
                              reciterDisplayName: r.audioArtist,
                              sourceUrl: r.mp3Url,
                              sourceRecitationId: r.id,
                              syncXml: r.xmlText,
                              cs: cs,
                            ),
                            DefaultReciterStar(
                              category: widget.category,
                              reciterKey: reciterKey,
                              reciterDisplayName: r.audioArtist,
                              cs: cs,
                              onSetDefault: () {
                                widget.ctrl.selectRecitation(widget.poemId, r);
                                widget.onSelect(r);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
