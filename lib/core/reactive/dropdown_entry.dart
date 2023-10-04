import 'package:equatable/equatable.dart';

abstract class IsEmptyInterface {
  bool get isEmpty;
  bool get isNotEmpty;
}

int compareDropDownEntry(DropDownEntry a, DropDownEntry b) => a.label.toLowerCase().compareTo(b.label.toLowerCase());

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
