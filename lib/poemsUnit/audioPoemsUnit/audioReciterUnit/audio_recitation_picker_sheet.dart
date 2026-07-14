import 'package:flutter/material.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_download_control.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/set_default_reciter.dart';

class RecitationPickerSheet extends StatefulWidget {
  final List<RecitationInfo> recitations;
  final RecitationInfo? selected;
  final ThemeData theme;
  final ColorScheme cs;
  final String poemId;
  final String category;
  final String poemTitle;
  final void Function(RecitationInfo) onSelect;

  const RecitationPickerSheet({
    super.key,
    required this.recitations,
    required this.selected,
    required this.theme,
    required this.cs,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.onSelect,
  });

  @override
  State<RecitationPickerSheet> createState() => _RecitationPickerSheetState();
}

class _RecitationPickerSheetState extends State<RecitationPickerSheet> {
  late final TextEditingController _searchCtrl;
  late List<RecitationInfo> _filtered;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
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
              ),
            ),
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
                        final reciterKey = ReciterKey.from(r.audioArtist);

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
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: cs.primary,
                                  ),
                                ],
                                const SizedBox(width: 4),
                                ReciterDownloadControl(
                                  poemId: widget.poemId,
                                  category: widget.category,
                                  poemTitle: widget.poemTitle,
                                  reciterKey: reciterKey,
                                  reciterDisplayName: r.audioArtist,
                                  sourceUrl: r.mp3Url,
                                  sourceRecitationId: r.id,
                                  cs: cs,
                                ),
                                DefaultReciterStar(
                                  poemId: widget.poemId,
                                  reciterKey: reciterKey,
                                  cs: cs,
                                ),
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
