import 'package:document_scanner/core/lib/language_name.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:equatable/equatable.dart';

abstract class IsEmptyInterface {
  bool get isEmpty;
  bool get isNotEmpty;
}

int compareLabel(I18nLabel a, I18nLabel b) => a.label.toLowerCase().compareTo(b.label.toLowerCase());

class I18nLabel extends Equatable implements IsEmptyInterface {
  static final I18nLabel empty = I18nLabel(emptyI18nLabels, "");

  final Map<String, String> _label;
  final String _technical;

  @override
  String toString() => "$_label ($technical)";

  String get label {
    if (!_label.containsKey(AppLang.lang)) {
      return _label.entries.first.value;
    }

    return _label[AppLang.lang]!;
  }

  factory I18nLabel.build({
    required String label,
  }) {
    final t = label.split(";").asMap().map((key, value) {
      if (value.length > 2 && value[2] == ':') {
        final k = value.substring(0, 2);
        final v = value.substring(3);
        return MapEntry(k, v);
      }

      return MapEntry("", value);
    });

    return I18nLabel(
      t,
      t[""] ?? label,
    );
  }

  const I18nLabel(
    Map<String, String> label,
    String technical,
  )   : _label = label,
        _technical = technical;

  @override
  bool get isEmpty => _technical.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [_technical];

  get technical => _technical;
}
