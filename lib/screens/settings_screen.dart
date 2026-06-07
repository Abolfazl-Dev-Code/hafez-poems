import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/ghazal_action_controller.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/services/app_snackbar_service.dart';
import 'package:hafez_poems/services/notification_service.dart';
import 'package:hafez_poems/services/theme_reveal_service.dart';
import 'package:hafez_poems/theme/text_style.dart';
import 'package:hafez_poems/theme/theme_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  static const String _fontSizeKey = 'reading_font_size';
  static const String _lineHeightKey = 'reading_line_height';
  static const String _fontFamilyKey = 'reading_font_family';
  static const String _fontColorKey = 'reading_font_color';
  static const String _dailyReminderKey = 'daily_ghazal_reminder_enabled';

  double _fontSize = 20;
  double _lineHeight = 1.9;
  String _fontFamily = 'vazir';
  int _fontColorValue = 0xFF000000;
  bool _dailyReminderEnabled = false;
  int _reminderHour = 13;
  int _reminderMinute = 0;
  String _appVersion = '...';
  bool _isTogglingReminder = false;

  late final AnimationController _snackProgressController;

  static const fontOptions = [
    {'label': 'وزیر', 'value': 'vazir'},
    {'label': 'مروارید', 'value': 'morvarid'},
  ];

  final List<Color> _fontColors = const [
    Color(0xFF000000),
    Color(0xFF1F2937),
    Color(0xFF374151),
    Color(0xFF6B21A8),
    Color(0xFF0F766E),
    Color(0xFFB91C1C),
    Color(0xFFFFFFFF),
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppVersion();
    _snackProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _snackProgressController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    const validFonts = ['vazir', 'morvarid'];

    final savedFont = prefs.getString(_fontFamilyKey) ?? 'vazir';
    final savedReminder = prefs.getBool(_dailyReminderKey) ?? false;
    final isReminderScheduled = await NotificationService.instance
        .isDailyReminderScheduled();

    final reminderEnabled = savedReminder && isReminderScheduled;
    _reminderHour = prefs.getInt('notif_hour') ?? 13;
    _reminderMinute = prefs.getInt('notif_minute') ?? 0;
    if (savedReminder != reminderEnabled) {
      await prefs.setBool(_dailyReminderKey, reminderEnabled);
    }

    if (!mounted) return;

    setState(() {
      _fontSize = prefs.getDouble(_fontSizeKey) ?? 20;
      _lineHeight = prefs.getDouble(_lineHeightKey) ?? 1.9;
      _fontFamily = validFonts.contains(savedFont) ? savedFont : 'vazir';
      _fontColorValue = prefs.getInt(_fontColorKey) ?? 0xFF000000;
      _dailyReminderEnabled = reminderEnabled;
      _reminderHour = prefs.getInt('notif_hour') ?? 13;
      _reminderMinute = prefs.getInt('notif_minute') ?? 0;
    });
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, value);
    setState(() => _fontSize = value);
  }

  Future<void> _saveLineHeight(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lineHeightKey, value);
    setState(() => _lineHeight = value);
  }

  Future<void> _saveFontFamily(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, value);
    setState(() => _fontFamily = value);
  }

  Future<void> _saveFontColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontColorKey, color.toARGB32());
    setState(() => _fontColorValue = color.toARGB32());
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

    setState(() {
      _reminderHour = picked.hour;
      _reminderMinute = picked.minute;
    });

    if (_dailyReminderEnabled) {
      await NotificationService.instance.scheduleDailyReminderAt(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (!mounted) return;
      AppSnackBarService.success(
        context,
        'زمان یادآوری به ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} تغییر کرد',
      );
    }
  }

  Future<void> _toggleReminder(bool enabled) async {
    if (_isTogglingReminder) return;

    setState(() => _isTogglingReminder = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      if (enabled) {
        final granted = await NotificationService.instance
            .requestReminderPermissions();

        if (!granted) {
          if (!mounted) return;
          setState(() => _dailyReminderEnabled = false);
          AppSnackBarService.error(context, 'اجازه ارسال نوتیفیکیشن داده نشد');
          return;
        }

        await NotificationService.instance.scheduleDailyReminder();

        final isScheduled = await NotificationService.instance
            .isDailyReminderScheduled();

        await prefs.setBool(_dailyReminderKey, isScheduled);

        if (!mounted) return;
        setState(() => _dailyReminderEnabled = isScheduled);

        if (isScheduled) {
          AppSnackBarService.success(context, 'یادآوری روزانه فعال شد');
        }
      } else {
        await NotificationService.instance.cancelDailyReminder();

        final isStillScheduled = await NotificationService.instance
            .isDailyReminderScheduled();

        final reminderEnabled = isStillScheduled;
        await prefs.setBool(_dailyReminderKey, reminderEnabled);

        if (!mounted) return;
        setState(() => _dailyReminderEnabled = reminderEnabled);

        if (!isStillScheduled) {
          AppSnackBarService.success(context, 'یادآوری روزانه غیرفعال شد');
        } else {
          AppSnackBarService.error(
            context,
            'غیرفعال‌سازی یادآوری روزانه انجام نشد',
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingReminder = false);
      }
    }
  }

  Future<void> _showDeleteAllLocalDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'حذف تمامی داده‌های محلی',
              style: AppTextStyles.bodyMediumSetting.copyWith(fontSize: 19),
              textAlign: TextAlign.right,
            ),
            content: Text.rich(
              TextSpan(
                style: AppTextStyles.titleMediumSetting.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.8,
                ),
                children: [
                  const TextSpan(text: 'آیا از '),
                  TextSpan(
                    text: 'حذف',
                    style: AppTextStyles.titleMediumSetting.copyWith(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' کامل تمامی داده‌های محلی برنامه اطمینان دارید؟\n'
                        'این عملیات شامل لایک‌ها، ذخیره‌ها، هایلایت‌ها و تنظیمات ذخیره‌شده خواهد بود.',
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  backgroundColor: Colors.green.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.green.withValues(alpha: 0.20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('لغو'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  backgroundColor: Colors.red.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      await _deleteAllLocalData();
    }
  }

  Future<void> _deleteAllLocalData() async {
    try {
      // پاک کردن همه box ها با name های صحیح
      await Hive.box<LikedItem>(GhazalActionController.likedBoxName).clear();
      await Hive.box<SavedItem>(GhazalActionController.savedBoxName).clear();
      await Hive.box<HighlightItem>(
        GhazalActionController.highlightBoxName,
      ).clear();

      // پاک کردن تنظیمات
      final prefs = await SharedPreferences.getInstance();
      await NotificationService.instance.cancelDailyReminder();
      await prefs.clear();

      // ریست تنظیمات به دیفالت
      await _loadSettings();

      if (!mounted) return;
      AppSnackBarService.success(context, 'تمام داده‌های محلی حذف شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'خطا در حذف داده‌ها: $e');
    }
  }

  Future<void> _introduceToFriends() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              'من دارم از این اپ برای خواندن غزل‌های حافظ استفاده می‌کنم.\n'
              'تو هم امتحانش کن 🌿\n'
              'لینک برنامه به‌زودی اضافه می‌شود.',
          subject: 'معرفی به دوستان',
        ),
      );

      if (!mounted) return;
      AppSnackBarService.success(context, 'پنجره اشتراک‌گذاری باز شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'اشتراک‌گذاری انجام نشد');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'امکان باز کردن لینک وجود ندارد');

      return;
    }
  }

  void _showAboutDialogCustom() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
            actionsPadding: const EdgeInsets.only(left: 16, bottom: 10),

            title: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  'درباره ما',
                  style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                    fontFamily: _fontFamily,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            content: SingleChildScrollView(
              child: Text(
                'این برنامه با هدف ایجاد تجربه‌ای آرام و دلنشین برای خواندن غزل‌های حافظ طراحی شده است.\n\n'
                'تلاش ما این است که مطالعه شعر فارسی را ساده‌تر، زیباتر و شخصی‌سازی‌شده‌تر کنیم تا هر کاربر بتواند '
                'با فضای شعر و ادب فارسی ارتباطی عمیق‌تر برقرار کند.',
                textAlign: TextAlign.right,
                style: AppTextStyles.titleMediumSetting.copyWith(
                  height: 1.8,
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('بستن'),
                    const SizedBox(width: 4),
                    const Icon(Icons.close, size: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            title: Row(
              children: [
                Icon(Icons.lock_outline, color: colorScheme.primary, size: 26),
                const SizedBox(width: 10),
                Text(
                  'حریم خصوصی',
                  style: AppTextStyles.bodyMediumSetting.copyWith(
                    fontSize: 19,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            content: SingleChildScrollView(
              child: Text(
                'اطلاعات شخصی شما در این برنامه به‌صورت محلی نگهداری می‌شود و بدون رضایت شما '
                'به جایی ارسال نخواهد شد.\n\n'
                'تنظیمات مطالعه، داده‌های ذخیره‌شده و وضعیت نوتیفیکیشن‌ها فقط برای بهبود تجربه کاربری '
                'در داخل دستگاه شما استفاده می‌شوند.',
                textAlign: TextAlign.right,
                style: AppTextStyles.titleMediumSetting.copyWith(
                  height: 1.8,
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('متوجه شدم'),
                    const SizedBox(width: 4),
                    const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.22 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: titleColor ?? colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
        trailing: trailing,
        onTap: enabled ? onTap : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final previewColor = Color(_fontColorValue);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(
                        alpha: isDark ? 0.22 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  final darkMode = themeController.isDarkMode.value;
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "حالت نمایش",
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              darkMode
                                  ? "حالت تیره فعال است"
                                  : "حالت روشن فعال است",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ThemeModeIconToggle(
                        isDarkMode: darkMode,
                        onTap: () {
                          final newDarkMode = !darkMode;
                          themeController.toggleTheme(newDarkMode);

                          // اضافه کردن منطق تغییر خودکار رنگ فونت:
                          if (newDarkMode) {
                            // اگر رفت روی دارک مود، رنگ فونت سفید شود
                            _saveFontColor(const Color(0xFFFFFFFF));
                          } else {
                            // اگر رفت روی لایت مود، رنگ فونت سیاه شود
                            _saveFontColor(const Color(0xFF000000));
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context: context,
                title: 'تنظیمات مطالعه',
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اندازه فونت: ${_fontSize.toStringAsFixed(0)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 14,
                      max: 25,
                      divisions: 11,
                      label: _fontSize.toStringAsFixed(0),
                      onChanged: (value) => _saveFontSize(value),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'فاصله خطوط بیت‌ها: ${_lineHeight.toStringAsFixed(1)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _lineHeight,
                      min: 1.2,
                      max: 2.2,
                      divisions: 10,
                      label: _lineHeight.toStringAsFixed(1),
                      onChanged: (value) => _saveLineHeight(value),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'انتخاب فونت',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _fontFamily,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(16),
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
                                  if (_fontFamily == value) ...[
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
                            final value = font['value']!;
                            final label = font['label']!;
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                label,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: value,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          _saveFontFamily(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'رنگ فونت',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _fontColors.map((color) {
                      final selected = color.toARGB32() == _fontColorValue;
                      return GestureDetector(
                        onTap: () => _saveFontColor(color),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? colorScheme.primary
                                  : theme.dividerColor,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'الا یا ایها الساقی ادر کاساً و ناولها',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: _lineHeight,
                        fontFamily: _fontFamily,
                        color: previewColor,
                      ),
                    ),
                  ),
                ],
              ),
              _buildSectionCard(
                context: context,
                title: 'یادآوری خواندن اشعار حافظ',
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _dailyReminderEnabled,
                    onChanged: _isTogglingReminder ? null : _toggleReminder,
                    title: Text(
                      'فعال‌سازی نوتیف',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'این گزینه برای ارسال یادآوری روزانه خواندن اشعار است.',
                    ),
                  ),
                  if (_dailyReminderEnabled) ...[
                    const Divider(height: 1),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickReminderTime,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                                Text(
                                  'زمان یادآوری',
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Text(
                              '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}',
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
              ),
              _buildSectionCard(
                context: context,
                title: 'مدیریت داده‌ها',
                children: [
                  _buildTile(
                    context: context,
                    title: 'حذف تمامی داده‌های محلی',
                    subtitle:
                        'لایک‌ها، ذخیره‌ها، هایلایت‌ها و تنظیمات ذخیره‌شده پاک می‌شوند.',
                    titleColor: colorScheme.error,
                    onTap: _showDeleteAllLocalDataDialog,
                  ),
                ],
              ),
              _buildSectionCard(
                context: context,
                title: 'درباره برنامه',
                children: [
                  _buildTile(
                    context: context,
                    title: 'نسخه برنامه',
                    subtitle: _appVersion,
                  ),
                  _buildTile(
                    context: context,
                    title: 'راه‌های ارتباطی',
                    subtitle: 'ایمیل و شبکه‌های ارتباطی',
                    onTap: () => _openContactOptions(),
                  ),
                  _buildTile(
                    context: context,
                    title: 'درباره ما',
                    onTap: _showAboutDialogCustom,
                  ),
                  _buildTile(
                    context: context,
                    title: 'حریم خصوصی',
                    onTap: _showPrivacyDialog,
                  ),
                ],
              ),
              _buildSectionCard(
                context: context,
                title: 'اشتراک‌گذاری و حمایت',
                children: [
                  _buildTile(
                    context: context,
                    title: 'معرفی به دوستان',
                    onTap: _introduceToFriends,
                  ),
                  _buildTile(
                    context: context,
                    title: 'امتیاز دادن به برنامه',
                    subtitle: 'این گزینه پس از انتشار برنامه فعال می‌شود.',
                    enabled: false,
                    trailing: const Icon(Icons.lock_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openContactOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('ایمیل', textAlign: TextAlign.right),
                    subtitle: const Text(
                      'nashenaskhamosh@gmail.com',
                      textAlign: TextAlign.right,
                    ),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {
                      Navigator.pop(context);
                      _openUrl('mailto:nashenaskhamosh@gmail.com');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.telegram),
                    title: const Text('تلگرام', textAlign: TextAlign.right),
                    subtitle: const Text(
                      't.me/dotb1',
                      textAlign: TextAlign.right,
                    ),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {
                      Navigator.pop(context);
                      _openUrl('https://t.me/dotb1');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text('اینستاگرام', textAlign: TextAlign.right),
                    subtitle: const Text(
                      'Should_call_me_nostradamus',
                      textAlign: TextAlign.right,
                    ),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () {
                      Navigator.pop(context);
                      _openUrl(
                        'https://instagram.com/Should_call_me_nostradamus',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeModeIconToggle extends StatefulWidget {
  const _ThemeModeIconToggle({required this.isDarkMode, required this.onTap});

  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  State<_ThemeModeIconToggle> createState() => _ThemeModeIconToggleState();
}

class _ThemeModeIconToggleState extends State<_ThemeModeIconToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // ── آنیمیشن‌های مجزا ──────────────────────────────────────────────────────
  late final Animation<double> _rotateAnim; // چرخش کل
  late final Animation<double> _scaleAnim; // بزرگ‌شدن موقع ورود
  late final Animation<Offset> _slideOut; // خروج آیکون قدیمی
  late final Animation<Offset> _slideIn; // ورود آیکون جدید
  late final Animation<double> _glowAnim; // درخشش پس‌زمینه

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _buildAnimations();

    if (widget.isDarkMode) {
      _ctrl.value = 1.0;
    } else {
      _ctrl.value = 0.0;
    }
  }

  void _buildAnimations() {
    // چرخش ۳۶۰° با ease
    _rotateAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutBack));

    // scale: از ۰.۶ به ۱.۰ با overshoot
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.15), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // آیکون قدیمی از مرکز به پایین میره
    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.6))
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
          ),
        );

    // آیکون جدید از بالا میاد
    _slideIn = Tween<Offset>(begin: const Offset(0, -1.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.45, 1.0, curve: Curves.easeOutBack),
          ),
        );

    // درخشش پس‌زمینه در وسط انیمیشن
    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_ThemeModeIconToggle old) {
    super.didUpdateWidget(old);
    if (old.isDarkMode != widget.isDarkMode) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // رنگ درخشش بر اساس حالت مقصد
    final glowColor = widget.isDarkMode
        ? const Color(0xFF7C4DFF) // بنفش برای dark
        : const Color(0xFFFFB300); // زرد برای light

    return GestureDetector(
      onTap: () {
        final box = context.findRenderObject() as RenderBox?;
        final pos =
            box?.localToGlobal(box.size.center(Offset.zero)) ??
            Offset(MediaQuery.of(context).size.width / 2, 100);

        ThemeRevealService.instance.reveal(
          context: context,
          origin: pos,
          toDark: !widget.isDarkMode,
          onSwitch: widget.onTap,
        );
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.8),
              ),
              // درخشش پویا
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: _glowAnim.value * 0.85),
                  blurRadius: 22 + _glowAnim.value * 22,
                  spreadRadius: _glowAnim.value * 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── پس‌زمینه رنگی متحرک ─────────────────────────────
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.85,
                          colors: widget.isDarkMode
                              ? [
                                  const Color(
                                    0xFF2D1B69,
                                  ).withValues(alpha: 0.35),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(
                                    0xFFFFF3CD,
                                  ).withValues(alpha: 0.5),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),

                  // ── آیکون قدیمی — خروج (حالت فعلی) ─────────────────
                  SlideTransition(
                    position: _slideOut,
                    child: Opacity(
                      opacity: (1.0 - _ctrl.value * 2.2).clamp(0.0, 1.0),
                      child: _buildIcon(isDark: widget.isDarkMode, scale: 1.0),
                    ),
                  ),

                  // ── آیکون جدید — ورود (حالت بعدی) ──────────────────
                  SlideTransition(
                    position: _slideIn,
                    child: Opacity(
                      opacity: ((_ctrl.value - 0.4) * 1.8).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: RotationTransition(
                          turns: _rotateAnim,
                          child: _buildIcon(
                            isDark: widget.isDarkMode,
                            scale: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon({required bool isDark, required double scale}) {
    return Icon(
      isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
      size: 26 * scale,
      color: isDark ? const Color(0xFF7C4DFF) : const Color(0xFFFFB300),
    );
  }
}
