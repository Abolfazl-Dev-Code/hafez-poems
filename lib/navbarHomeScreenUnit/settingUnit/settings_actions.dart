part of 'settings_screen.dart';

extension _SettingsActions on _SettingPageState {
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final validFonts = _SettingPageState.fontOptions
        .map((f) => f['value'])
        .toSet();

    final savedFont =
        prefs.getString(_SettingPageState._fontFamilyPrefKey) ?? 'vazir';
    final savedReminder =
        prefs.getBool(_SettingPageState._dailyReminderPrefKey) ?? false;
    final isReminderScheduled = await NotificationService.instance
        .isDailyReminderScheduled()
        .timeout(
          const Duration(milliseconds: 300),
          onTimeout: () => savedReminder,
        );

    final reminderEnabled = savedReminder && isReminderScheduled;
    if (savedReminder != reminderEnabled) {
      await prefs.setBool(
        _SettingPageState._dailyReminderPrefKey,
        reminderEnabled,
      );
    }
    if (!mounted) return;
    _applyLoadedSettings(
      fontSize: prefs.getDouble(_SettingPageState._fontSizePrefKey) ?? 13,
      lineHeight: prefs.getDouble(_SettingPageState._lineHeightPrefKey) ?? 1,
      fontFamily: validFonts.contains(savedFont) ? savedFont : 'vazir',
      fontColorValue:
          prefs.getInt(_SettingPageState._fontColorPrefKey) ?? 0xFF000000,
      dailyReminderEnabled: reminderEnabled,
      reminderHour: prefs.getInt(_SettingPageState._reminderHourPrefKey) ?? 13,
      reminderMinute:
          prefs.getInt(_SettingPageState._reminderMinutePrefKey) ?? 0,
    );
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    _setAppVersion('${info.version} (${info.buildNumber})');
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_SettingPageState._fontSizePrefKey, value);
    _setFontSize(value);
  }

  Future<void> _saveLineHeight(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_SettingPageState._lineHeightPrefKey, value);
    _setLineHeight(value);
  }

  Future<void> _saveFontFamily(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_SettingPageState._fontFamilyPrefKey, value);
    _setFontFamily(value);
  }

  Future<void> _saveFontColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_SettingPageState._fontColorPrefKey, color.toARGB32());
    _setFontColorValue(color.toARGB32());
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
      helpText: 'زمان یادآوری را انتخاب کنید',
    );
    if (picked == null || !mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hour', picked.hour);
    await prefs.setInt('notif_minute', picked.minute);
    _setReminderTime(picked.hour, picked.minute);
    if (_dailyReminderEnabled) {
      await NotificationService.instance.scheduleDailyReminderAt(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (!mounted) return;
      AppSnackBarService.success(
        'زمان یادآوری به $_reminderTimeText تغییر کرد',
      );
    }
  }

  Future<void> _toggleReminder(bool enabled) async {
    if (_isTogglingReminder) return;
    _setIsTogglingReminder(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (enabled) {
        final granted = await NotificationService.instance
            .requestReminderPermissions();
        if (!granted) {
          if (!mounted) return;
          _setDailyReminderEnabled(false);
          AppSnackBarService.error('اجازه ارسال اعلان‌ها داده نشد');
          return;
        }
        await NotificationService.instance.scheduleDailyReminder();
        final isScheduled = await NotificationService.instance
            .isDailyReminderScheduled();
        await prefs.setBool(
          _SettingPageState._dailyReminderPrefKey,
          isScheduled,
        );
        if (!mounted) return;
        _setDailyReminderEnabled(isScheduled);
        if (isScheduled) {
          AppSnackBarService.success('یادآوری روزانه فعال شد');
        }
      } else {
        await NotificationService.instance.cancelDailyReminder();
        final isStillScheduled = await NotificationService.instance
            .isDailyReminderScheduled();
        await prefs.setBool(
          _SettingPageState._dailyReminderPrefKey,
          isStillScheduled,
        );
        if (!mounted) return;
        _setDailyReminderEnabled(isStillScheduled);
        if (!isStillScheduled) {
          AppSnackBarService.success('یادآوری روزانه غیرفعال شد');
        } else {
          AppSnackBarService.error(
            'غیرفعال‌سازی یادآوری روزانه انجام نشد\nاز تنظیمات تلفن اقدام کنید',
          );
        }
      }
    } finally {
      if (mounted) _setIsTogglingReminder(false);
    }
  }

  Future<void> _showDeleteAllLocalDataDialog() async {
    final confirmed = await showDeleteDataDialog(context);
    if (confirmed == true) await _deleteAllLocalData();
  }

  Future<void> _deleteAllLocalData() async {
    try {
      await Get.find<IKeyedItemStorage<LikedItem>>().clear();
      await Get.find<IKeyedItemStorage<SavedItem>>().clear();
      await Get.find<IKeyedItemStorage<HighlightItem>>().clear();
      final prefs = await SharedPreferences.getInstance();
      await NotificationService.instance.cancelDailyReminder();
      await prefs.clear();
      await _loadSettings();
      if (!mounted) return;
      AppSnackBarService.success('تمام داده‌های محلی حذف شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error('خطا در حذف داده‌ها: $e');
    }
  }

  Future<void> _introduceToFriends() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              '✨ اگر عاشق شعر و فال حافظی، این برنامه رو حتماً امتحان کن!\n\n'
              '📖 مجموعه کامل غزل‌های حافظ\n'
              '🔮 فال حافظ با رابط کاربری زیبا\n'
              '⚡ سریع، سبک و کاملاً رایگان\n\n'
              '👇 لینک دانلود:\n'
              'https://github.com/Abolfazl-Dev-Code/hafez-poems/releases',
          subject: 'معرفی به دوستان',
        ),
      );
      if (!mounted) return;
      AppSnackBarService.success('پنجره اشتراک‌گذاری باز شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error('اشتراک‌گذاری انجام نشد');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      AppSnackBarService.error('امکان باز کردن لینک وجود ندارد');
    }
  }

  void _openContactOptions() {
    showContactOptions(
      context: context,
      onEmailTap: () => _openUrl('mailto:nashenaskhamosh@gmail.com'),
      onTelegramTap: () => _openUrl('https://t.me/dotb1'),
      onWebsiteTap: () =>
          _openUrl('https://instagram.com/should_call_me_nostradamus'),
    );
  }
}
