import 'package:document_scanner/core/lib/language_name.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DropDownBlocBuilder extends DropdownFieldBlocBuilder<I18nLabel> {
  DropDownBlocBuilder({
    required SelectFieldBloc<I18nLabel, dynamic> bloc,
    required String hint,
    bool requestFocus = false,
    bool isEnabled = true,
    String? label,
    super.onChanged,
    super.key,
  }) : super(
          isEnabled: isEnabled,
          selectFieldBloc: bloc,
          decoration: InputDecoration(
            labelText: label,
            hintStyle: const TextStyle(color: Colors.amber),
          ),
          emptyItemLabel: AppLang.i18n.dropdown_empty_hint(hint),
          itemBuilder: (context, item) {
            return FieldItem(child: Text(item.label));
          },
        );
}

abstract class IsEmptyInterface {
  bool get isEmpty;
  bool get isNotEmpty;
}

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

class I18nValuesIcon {
  final I18nLabel label;
  final int codePoint;

  I18nValuesIcon(this.label, this.codePoint);
}

class I18nValues {
  final Map<String, I18nLabel> values;
  final int flex;
  final bool hidden;
  final String type;
  final String meaning;
  final List<I18nValuesIcon> iconData;
  final I18nLabel label;

  I18nValues({
    required String label,
    required List<String> values,
    required this.type,
    required this.meaning,
    required this.iconData,
    required this.flex,
    required this.hidden,
  })  : values = values.asMap().map(convert),
        label = I18nLabel.build(label: label);

  static MapEntry<String, I18nLabel> convert(int key, String value) => entry(I18nLabel.build(label: value));
  static MapEntry<String, I18nLabel> entry(I18nLabel e) => MapEntry(e.technical, e);

  @override
  String toString() => "$label: [$type] $values";

  Map<String, int> get iconDataMap =>
      iconData.asMap().map((_, value) => MapEntry(value.label.technical, value.codePoint));
}
