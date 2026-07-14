class PoemCategoryLabels {
  PoemCategoryLabels._();

  static const Map<String, String> _labels = {
    'ghazal': 'Ghazal',
    'ghataat': 'Ghataat',
    'ghasayed': 'Ghasayed',
    'robaeyat': 'Robaeyat',
    'montasab': 'Montasab',
    'other': 'Other',
  };

  static String labelFor(String category) => _labels[category] ?? category;
}
