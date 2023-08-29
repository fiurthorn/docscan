enum KeyValueNames {
  locale,
  //
  senderNames,
  receiverNames,
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

  Future<void> setItems(KeyValueNames key, List<String> list);
  Future<List<String>> getItems(KeyValueNames key);
  Future<void> addSenderName(String senderName);

  Future<void> init();

  Future<void> exportDatabase();

  Future<void> importDatabase(Map<dynamic, dynamic> map);
}
