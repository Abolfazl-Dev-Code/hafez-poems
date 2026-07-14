import 'package:hafez_poems/models/search_result.dart';

String poemCategoryFor(SearchResultType type) {
  switch (type) {
    case SearchResultType.ghazal:
      return 'ghazal';
    case SearchResultType.ghataat:
      return 'ghataat';
    case SearchResultType.qasaid:
      return 'ghasayed';
    case SearchResultType.robaeyat:
      return 'robaeyat';
    case SearchResultType.montasab:
      return 'montasab';
    case SearchResultType.other:
      return 'other';
  }
}
