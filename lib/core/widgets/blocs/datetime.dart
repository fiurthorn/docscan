import 'package:document_scanner/core/lib/states/validators.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class DateTimeBloc<ExtraData> extends TextFieldBloc<ExtraData> {
  final DateFormat format;

  DateTimeBloc._({
    required this.format,
    super.name,
    super.validators,
    super.extraData,
    super.initialValue,
  });

  factory DateTimeBloc.create({
    String? name,
    DateTime? initialValue,
    List<Validator<String>>? validators,
    ExtraData? extraData,
  }) {
    final format = DateFormat.yMd(AppLang.lang);
    final initialStringValue = format.format(initialValue ?? DateTime.now());

    final bloc = DateTimeBloc._(
      format: format,
      name: name,
      validators: validators,
      initialValue: initialStringValue,
      extraData: extraData,
    );
    bloc.addValidators([isDateTime(format: bloc.format)]);

    return bloc;
  }

  DateTime? get dateTime => value.isNotEmpty //
      ? format.parse(value, true)
      : null;

  updateDateTimeValue(DateTime? value) {
    if (value != null) {
      final stringValue = format.format(value);
      updateValue(stringValue);
    }
  }

  changeDateTimeValue(DateTime? value) {
    if (value != null) {
      final stringValue = format.format(value);
      changeValue(stringValue);
    }
  }
}
