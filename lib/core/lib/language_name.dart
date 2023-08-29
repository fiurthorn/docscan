import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/l10n/translations/translations.dart';

const languageName = {
  "en": "English",
  "de": "Deutsch",
};

class LanguageTuple extends Tuple2<String, String> {
  String get name => b;
  String get code => a;

  const LanguageTuple(
    String code,
    String name,
  ) : super(
          code,
          name,
        );
}

final sortedLanguageNames = S.supportedLocales
    .map((e) => LanguageTuple(e.languageCode, languageName[e.languageCode] ?? e.languageCode))
    .toList()
  ..sort((a, b) => b.b.compareTo(a.b));

final sortedLocales = S.supportedLocales.map((e) => e.languageCode).toList()..sort((a, b) => b.compareTo(a));

final Map<String, String> emptyI18nLabels = sortedLocales.asMap().map((key, value) => MapEntry(value, ""));

Map<String, String> defaultI18nLabels(String label) =>
    sortedLocales.asMap().map((key, value) => MapEntry(value, label));
