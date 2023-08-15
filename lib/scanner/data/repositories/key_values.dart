import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:hive/hive.dart';

class KeyValuesImpl implements KeyValues {
  late final Box _box;

  KeyValuesImpl(Box keyValues) : _box = keyValues;

  @override
  bool flag(KeyValueNames key) => get(key) == "true";

  @override
  String get(KeyValueNames key, [String defaultValue = ""]) => (_box.get(key.name) ?? defaultValue);

  @override
  bool has(KeyValueNames key) => _box.containsKey(key.name);

  @override
  bool empty(KeyValueNames key) => !has(key) || get(key).isEmpty;

  @override
  bool notEmpty(KeyValueNames key) => has(key) && get(key).isNotEmpty;

  @override
  Future<void> set(KeyValueNames key, String value) async => _box.put(key.name, value);

  @override
  Future<void> remove(KeyValueNames key) async => _box.delete(key.name);

  @override
  Future<List<String>> documentTypeItems() async =>
      (await _box.get(KeyValueNames.documentTypes.name, defaultValue: const []) as List).map((e) => '$e').toList();

  @override
  Future<void> setAreaItems(List<String> list) async => _box.put(KeyValueNames.areas.name, list);

  @override
  Future<List<String>> areaItems() async =>
      (await _box.get(KeyValueNames.areas.name, defaultValue: const []) as List).map((e) => '$e').toList();

  @override
  Future<void> setDocumentTypeItems(List<String> list) async => _box.put(KeyValueNames.documentTypes.name, list);

  @override
  Future<List<String>> supplierNames() async =>
      (await _box.get(KeyValueNames.supplierNames.name, defaultValue: const []) as List).map((e) => '$e').toList();

  @override
  Future<void> setSupplierNames(List<String> list) async => _box.put(KeyValueNames.supplierNames.name, list);

  @override
  Future<void> addSupplierNames(String supplierName) async {
    if (!_box.containsKey(KeyValueNames.supplierNames.name)) {
      _box.put(KeyValueNames.supplierNames.name, [supplierName]);
      return;
    }

    supplierNames()
        .then((value) => value.contains(supplierName) ? null : value)
        .then((value) => value
          ?..add(supplierName)
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())))
        .then((value) => value == null ? null : _box.put(KeyValueNames.supplierNames.name, value));
  }

  @override
  close() => _box.close();
}
