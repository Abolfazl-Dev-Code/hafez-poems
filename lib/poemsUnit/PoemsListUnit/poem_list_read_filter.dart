part of 'poem_list_sheet.dart';

enum _ReadFilter { all, read, unread }

extension _ReadFilterLabel on _ReadFilter {
  String get label => switch (this) {
    _ReadFilter.all => 'همه',
    _ReadFilter.read => 'خوانده‌شده',
    _ReadFilter.unread => 'خوانده‌نشده',
  };

  IconData get icon => switch (this) {
    _ReadFilter.all => Icons.format_list_bulleted_rounded,
    _ReadFilter.read => Icons.radio_button_unchecked_rounded,
    _ReadFilter.unread => Icons.radio_button_unchecked_rounded,
  };

  IconData get activeIcon => switch (this) {
    _ReadFilter.all => Icons.format_list_bulleted_rounded,
    _ReadFilter.read => Icons.check_circle_rounded,
    _ReadFilter.unread => Icons.check_circle_rounded,
  };
}
