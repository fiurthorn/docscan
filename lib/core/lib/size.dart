import 'package:document_scanner/l10n/app_lang.dart';
import 'package:intl/intl.dart';

final _prefixes = <String>["", "k", "M", "G", "T", "P", "E"];

String displaySize(double size) {
  final format = NumberFormat('###0.#', AppLang.lang);

  int index = 0;
  while (size > 1000) {
    size /= 1000;
    index++;
  }
  return "${format.format(size)} ${_prefixes[index]}B";
}
