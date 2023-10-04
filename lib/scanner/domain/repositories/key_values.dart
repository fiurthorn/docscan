enum KeyValueNames {
  locale,
  //
  senderNames,
  receiverNames,
  documentTypes,
  areas,
  //
  listsInitOnStartup,
  lastBuildNumber,
}

extension KeyValueNamesExtension on KeyValueNames {
  String get name {
    return toString().substring(runtimeType.toString().length + 1);
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
  List<String> getItems(KeyValueNames key);
  Future<void> addSenderName(String senderName);

  Future<void> init();
  bool hasNewBuildNumber();
  void resetBuildNumber();

  Future<void> exportDatabase();

  Future<void> importDatabase(Map<dynamic, dynamic> map);
}
