import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DropDownBlocBuilder extends DropdownFieldBlocBuilder<DropDownEntry> {
  DropDownBlocBuilder({
    required SelectFieldBloc<DropDownEntry, dynamic> bloc,
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
            hintStyle: const TextStyle(color: nord12AuroraOrange),
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

class DropDownEntry extends Equatable implements IsEmptyInterface {
  static const DropDownEntry empty = DropDownEntry("", "");

  final String _label;
  final String _technical;

  @override
  String toString() => "$_label ($technical)";

  String get label => _label;
  String get technical => _technical;

  factory DropDownEntry.build({
    required String label,
  }) {
    final t = label.split(";");
    return DropDownEntry(t.first, t.last);
  }

  const DropDownEntry(
    String technical,
    String label,
  )   : _label = label,
        _technical = technical;

  @override
  bool get isEmpty => _technical.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [_technical];
}
