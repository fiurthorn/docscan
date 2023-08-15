enum KeyValueNames {
  locale,
  //
  supplierNames,
  documentTypes,
  areas,
}

extension KeyValueNamesExtension on KeyValueNames {
  String get name {
    return toString().substring(14);
  }
}

abstract class KeyValues {
  bool flag(KeyValueNames key) => get(key) == "true";

  String get(KeyValueNames key, [String defaultValue = ""]);
  Future<void> set(KeyValueNames key, String value);
  Future<void> remove(KeyValueNames key);

  bool empty(KeyValueNames key);
  bool notEmpty(KeyValueNames key);
  bool has(KeyValueNames key);

  Future<void> close();

  Future<List<String>> supplierNames();
  Future<void> setSupplierNames(List<String> list);
  Future<void> addSupplierNames(String supplierName);

  Future<List<String>> documentTypeItems();
  Future<void> setDocumentTypeItems(List<String> list);

  Future<List<String>> areaItems();
  Future<void> setAreaItems(List<String> list);

  Future<void> init();
}
