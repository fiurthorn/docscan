import 'package:document_scanner/l10n/translations/translations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_name.freezed.dart';

const languageName = {
  "en": "English",
  "de": "Deutsch",
};

@freezed
class LanguageTuple with _$LanguageTuple {
  factory LanguageTuple(
    String code,
    String name,
  ) = _LanguageTuple;
}

final sortedLanguageNames = S.supportedLocales
    .map((e) => LanguageTuple(e.languageCode, languageName[e.languageCode] ?? e.languageCode))
    .toList()
  ..sort((a, b) => b.name.compareTo(a.name));

final sortedLocales = S.supportedLocales.map((e) => e.languageCode).toList()..sort((a, b) => b.compareTo(a));

final Map<String, String> emptyI18nLabels = sortedLocales.asMap().map((key, value) => MapEntry(value, ""));

Map<String, String> defaultI18nLabels(String label) =>
    sortedLocales.asMap().map((key, value) => MapEntry(value, label));
