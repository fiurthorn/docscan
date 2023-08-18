import 'package:intl/intl.dart';
import 'package:document_scanner/l10n/app_lang.dart';

final _dateTimePattern = DateFormat.yMd().add_Hm();
final _numberPattern = NumberFormat.decimalPattern(AppLang.lang)..minimumFractionDigits = 2;

double toDouble(String value) {
  return _numberPattern.parse(value).toDouble();
}

String doubleToString(num value) {
  return _numberPattern.format(value);
}

String intToString(int value) {
  return doubleToString(value.toDouble());
}

String dateTimeToString(DateTime value) {
  return _dateTimePattern.format(value);
}

DateTime toDateTime(String value) {
  return _dateTimePattern.parse(value);
}
