import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/audio_player_controller.dart';
import 'package:hafez_poems/models/recitation_models.dart';

class RecitationDropdown extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged;

  const RecitationDropdown({
    super.key,
    required this.ctrl,
    required this.poemId,
    required this.theme,
    required this.cs,
    this.onRecitationChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (ctrl.isLoadingRecitations) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'دریافت خوانندگان...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.recitations.isEmpty) {
      return Container(
        height: 36,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 16,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 6),
            Text(
              'فایل صوتی برای این شعر موجود نیست \n یا اتصال شما به اینترنت کند است',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.recitations.length == 1) {
      return _ArtistChip(
        artist: ctrl.recitations.first.audioArtist,
        cs: cs,
        theme: theme,
      );
    }

    return _RecitationPickerButton(
      ctrl: ctrl,
      poemId: poemId,
      theme: theme,
      cs: cs,
      onRecitationChanged: onRecitationChanged,
    );
  }
}

// ── دکمه‌ای که bottom sheet رو باز می‌کنه ──
class _RecitationPickerButton extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged;

  const _RecitationPickerButton({
    required this.ctrl,
    required this.poemId,
    required this.theme,
    required this.cs,
    this.onRecitationChanged,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecitationPickerSheet(
        recitations: ctrl.recitations,
        selected: ctrl.selectedRecitation,
        theme: theme,
        cs: cs,
        onSelect: (r) {
          ctrl.selectRecitation(poemId, r);
          onRecitationChanged?.call(r);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = ctrl.selectedRecitation;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () => _openPicker(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.mic_rounded,
                size: 14,
                color: cs.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  selected?.audioArtist ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: cs.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Sheet با جستجو و لیست فیلترشده ──
class _RecitationPickerSheet extends StatefulWidget {
  final List<RecitationInfo> recitations;
  final RecitationInfo? selected;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo) onSelect;

  const _RecitationPickerSheet({
    required this.recitations,
    required this.selected,
    required this.theme,
    required this.cs,
    required this.onSelect,
  });

  @override
  State<_RecitationPickerSheet> createState() => _RecitationPickerSheetState();
}

class _RecitationPickerSheetState extends State<_RecitationPickerSheet> {
  late final TextEditingController _searchCtrl;
  late List<RecitationInfo> _filtered;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    // مرتب‌سازی بر اساس حروف الفبای فارسی
    _filtered = _sortedList(widget.recitations);
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── هندل ──
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── عنوان ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.mic_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'انتخاب خواننده',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filtered.length} خواننده',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── فیلد جستجو ──
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
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                autofocus: false,
              ),
            ),

            // ── لیست ──
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: _filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
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
                      shrinkWrap: true,
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

                        return InkWell(
                          onTap: () {
                            widget.onSelect(r);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cs.primary.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // آواتار
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
                                          : cs.onSurface.withValues(
                                              alpha: 0.55,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // نام خواننده
                                Expanded(
                                  child: Text(
                                    r.audioArtist,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? cs.primary
                                          : cs.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // تیک انتخاب
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: cs.primary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: bottomPadding + 12),
          ],
        ),
      ),
    );
  }
}

// ── تک‌خواننده ──
class _ArtistChip extends StatelessWidget {
  final String artist;
  final ColorScheme cs;
  final ThemeData theme;

  const _ArtistChip({
    required this.artist,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 14,
              color: cs.primary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                artist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
