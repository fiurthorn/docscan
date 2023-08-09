enum KeyValueNames {
  serverUrl,
  username,
  session,
  refresh,
  locale,
  loggedIn,
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

  String signOut();
  void signIn(String username, String session, String refresh);

  void close();
}
