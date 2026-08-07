import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_section_card.dart';

class SettingsReadingSection extends StatelessWidget {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final int fontColorValue;
  final List<Map<String, String>> fontOptions;
  final List<Color> fontColors;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<String> onFontFamilyChanged;
  final ValueChanged<Color> onFontColorChanged;

  const SettingsReadingSection({
    super.key,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontColorValue,
    required this.fontOptions,
    required this.fontColors,
    required this.onFontSizeChanged,
    required this.onLineHeightChanged,
    required this.onFontFamilyChanged,
    required this.onFontColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final previewColor = Color(fontColorValue);

    return SectionCard(
      title: 'تنظیمات مطالعه',
      icon: Icons.text_fields_outlined,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'اندازه قلم: ${fontSize.toStringAsFixed(0)}',
            style: textTheme.bodyMedium,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: fontSize,
            min: 10,
            max: 25,
            divisions: 15,
            label: fontSize.toStringAsFixed(0),
            onChanged: onFontSizeChanged,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'فاصله خطوط مصرع‌ها: ${lineHeight.toStringAsFixed(1)}',
            style: textTheme.bodyMedium,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: lineHeight,
            min: 1.0,
            max: 2.2,
            divisions: 12,
            label: lineHeight.toStringAsFixed(1),
            onChanged: onLineHeightChanged,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'انتخاب نوع قلم',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: fontFamily,
              isExpanded: true,
              borderRadius: AppRadius.lgRadius,
              dropdownColor: colorScheme.surface,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              alignment: Alignment.centerRight,
              items: fontOptions.map((font) {
                final value = font['value']!;
                final label = font['label']!;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              label,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: value,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        if (fontFamily == value) ...[
                          const SizedBox(width: 5),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return fontOptions.map((font) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      font['label']!,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: font['value'],
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList();
              },
              onChanged: (value) {
                if (value != null) onFontFamilyChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'رنگ قلم',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: fontColors.map((color) {
            final selected = color.toARGB32() == fontColorValue;
            return GestureDetector(
              onTap: () => onFontColorChanged(color),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? colorScheme.primary : theme.dividerColor,
                    width: selected ? 3 : 1.2,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: AppRadius.mdRadius,
          ),
          child: Text(
            'الا یا ایها الساقی ادر کاساً و ناولها',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              height: lineHeight,
              fontFamily: fontFamily,
              color: previewColor,
            ),
          ),
        ),
      ],
    );
  }
}
