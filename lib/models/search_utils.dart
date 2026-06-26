String normalize(String text) {
  return text
      // ✅ تبدیل اعداد فارسی و عربی به انگلیسی
      .replaceAll('۰', '0')
      .replaceAll('٠', '0')
      .replaceAll('۱', '1')
      .replaceAll('١', '1')
      .replaceAll('۲', '2')
      .replaceAll('٢', '2')
      .replaceAll('۳', '3')
      .replaceAll('٣', '3')
      .replaceAll('۴', '4')
      .replaceAll('٤', '4')
      .replaceAll('۵', '5')
      .replaceAll('٥', '5')
      .replaceAll('۶', '6')
      .replaceAll('٦', '6')
      .replaceAll('۷', '7')
      .replaceAll('٧', '7')
      .replaceAll('۸', '8')
      .replaceAll('٨', '8')
      .replaceAll('۹', '9')
      .replaceAll('٩', '9')
      // موارد قبلی
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\t', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}
