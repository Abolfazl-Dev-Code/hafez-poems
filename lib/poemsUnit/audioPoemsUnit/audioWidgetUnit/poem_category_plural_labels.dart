class PoemCategoryPluralLabels {
  PoemCategoryPluralLabels._();

  static const Map<String, String> _labels = {
    'ghazal': 'غزل‌ها',
    'ghataat': 'قطعات',
    'ghasayed': 'قصاید',
    'robaeyat': 'رباعیات',
    'montasab': 'اشعار منتسب',
    'other': 'اشعار دیگر',
  };

  static String labelFor(String category) => _labels[category] ?? 'اشعار';
}
