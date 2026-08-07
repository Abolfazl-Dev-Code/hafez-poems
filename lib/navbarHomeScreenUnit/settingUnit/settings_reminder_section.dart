import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_section_card.dart';

class SettingsReminderSection extends StatelessWidget {
  final bool dailyReminderEnabled;
  final bool isTogglingReminder;
  final String reminderTimeText;
  final ValueChanged<bool>? onToggle;
  final VoidCallback onPickTime;

  const SettingsReminderSection({
    super.key,
    required this.dailyReminderEnabled,
    required this.isTogglingReminder,
    required this.reminderTimeText,
    required this.onToggle,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SectionCard(
      title: 'یادآوری خواندن اشعار حافظ',
      icon: Icons.notifications_active_rounded,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: dailyReminderEnabled,
          onChanged: isTogglingReminder ? null : onToggle,
          title: Text(
            'فعال‌سازی اعلان‌ها',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'این گزینه برای ارسال یادآوری روزانه خواندن اشعار است.',
          ),
        ),
        if (dailyReminderEnabled) ...[
          const Divider(height: 1),
          InkWell(
            borderRadius: AppRadius.mdRadius,
            onTap: onPickTime,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text('زمان یادآوری', style: textTheme.bodyMedium),
                    ],
                  ),
                  Text(
                    reminderTimeText,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
