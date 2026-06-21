// ── Dropdown خواننده — راست‌چین صحیح در حالت باز و بسته ──────────────────

import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/audio_player_controller.dart';
import 'package:hafez_poems/models/recitation_models.dart';

class RecitationDropdown extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged; // ← اضافه
  const RecitationDropdown({
    super.key,
    required this.ctrl,
    required this.poemId,
    required this.theme,
    required this.cs,
    this.onRecitationChanged, // ← اضافه
  });

  @override
  Widget build(BuildContext context) {
    // در حال بارگذاری
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

    // فایل صوتی موجود نیست
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
              textAlign: TextAlign.center,
              'فایل صوتی برای این شعر موجود نیست \n یا اتصال شما به اینترنت کند است',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    // فقط یک خواننده — نمایش ساده بدون dropdown
    if (ctrl.recitations.length == 1) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 15,
              color: cs.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                ctrl.recitations.first.audioArtist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // چند خواننده — Dropdown
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<RecitationInfo>(
            value: ctrl.selectedRecitation,
            isExpanded: true,
            alignment: AlignmentDirectional.centerEnd, // ← راست‌چین دکمه‌ی بسته
            icon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: cs.primary,
              ),
            ),
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
            dropdownColor: cs.surface,
            borderRadius: BorderRadius.circular(12),
            // ── نمایش مقدار انتخاب‌شده در حالت بسته (راست‌چین) ──
            selectedItemBuilder: (context) {
              return ctrl.recitations.map((r) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mic_rounded,
                        size: 14,
                        color: cs.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          r.audioArtist,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            // ── آیتم‌های لیست باز شده (راست‌چین) ──
            items: ctrl.recitations.map((r) {
              return DropdownMenuItem<RecitationInfo>(
                alignment: AlignmentDirectional.centerEnd, // ← راست‌چین هر آیتم
                value: r,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mic_rounded,
                      size: 14,
                      color: cs.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        r.audioArtist,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: ctrl.isLoadingRecitations
                ? null
                : (recitation) {
                    if (recitation == null) return;
                    ctrl.selectRecitation(poemId, recitation);
                    onRecitationChanged?.call(recitation); // ← اضافه
                  },
          ),
        ),
      ),
    );
  }
}
