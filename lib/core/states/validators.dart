import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;

final RegExp emailPattern = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?){1,}$",
  multiLine: true,
);

final RegExp _invDecSep = RegExp("[^.,\u066B]");

Validator<String> notEmpty({String? error}) =>
    (v) => v.isEmpty ? _error(AppLang.i18n.validate_notEmpty_errorHint, error) : null;

Validator<dynamic> notEmptyObject({String? error}) =>
    (v) => (v == null || v.isEmpty) ? _error(AppLang.i18n.validate_notEmpty_errorHint, error) : null;

Validator<String> isNumber({String? error}) => (v) {
      if (v.isEmpty) {
        return null;
      }
      try {
        final pattern = NumberFormat.decimalPattern(AppLang.lang);
        final result = pattern.parse(v);

        final spread = v.replaceAll(_invDecSep, "");
        if (spread.isEmpty || spread.length == 1) {
          return null;
        }

        final sep = numberFormatSymbols[AppLang.lang].DECIMAL_SEP;
        final index = spread.indexOf(sep);
        if (index < 0 || index + 1 == spread.length) {
          return null;
        }

        return "${_error(AppLang.i18n.validate_notANumber_errorHint, error)}: ${pattern.format(result)}";
      } on FormatException {
        return _error(AppLang.i18n.validate_notANumber_errorHint, error);
      }
    };

Validator<String> isDateTime({required DateFormat format, String? error}) => (v) {
      if (v.isEmpty) {
        return null;
      }
      try {
        format.parseLoose(v);
        return null;
      } on FormatException {
        return _error(AppLang.i18n.validate_notADate_errorHint, error);
      }
    };

String _error(String i10n, String? error) {
  if (error == null) {
    return i10n;
  }
  return error;
}

Validator<String> minSize(int min, {String? error}) =>
    (v) => v.length < min ? _error(AppLang.i18n.validate_minLength_errorHint(min), error) : null;

Validator<String> maxSize(int max, {String? error}) =>
    (v) => v.length > max ? _error(AppLang.i18n.validate_maxLength_errorHint(max), error) : null;

Validator<String> matchRegex(RegExp matcher, {String? error}) =>
    (v) => !matcher.hasMatch(v) ? _error(AppLang.i18n.validate_regexMatch_errorHint, error) : null;

Validator<String> email({String? error}) =>
    matchRegex(emailPattern, error: error ?? AppLang.i18n.validate_email_errorHint);

Validator<List<T>> listNotEmpty<T>(String error) => (v) => v.isEmpty ? error : null;

typedef GroupValidator = bool Function(Object?);

class RequireGroup {
  final Map<SingleFieldBloc, GroupValidator> validators = {};

  void add(SingleFieldBloc bloc, GroupValidator validator) {
    validators[bloc] = validator;
  }

  Object? validate(dynamic value) {
    final result = validators //
        .entries
        .map((v) => v.value(v.key.state.value))
        .any((element) => element);
    return result ? null : AppLang.i18n.validate_notEmpty_errorHint;
  }
}
