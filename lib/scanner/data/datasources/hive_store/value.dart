import 'package:hive/hive.dart';
import 'package:sprintf/sprintf.dart';

part 'value.g.dart';

@HiveType(typeId: 1)
class Value extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final Map<dynamic, dynamic>? data;

  Value({required this.timestamp, this.data});

  @override
  String toString() {
    return sprintf("[Value:{%s}]", [timestamp.toIso8601String(), data]);
  }
}
