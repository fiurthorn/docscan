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
  close() => _box.close();

  @override
  String signOut() {
    final token = get(KeyValueNames.session);
    set(KeyValueNames.session, "");
    set(KeyValueNames.refresh, "");
    set(KeyValueNames.loggedIn, "false");
    return token;
  }

  @override
  void signIn(String username, String session, String refresh) {
    set(KeyValueNames.username, username);
    set(KeyValueNames.session, session);
    set(KeyValueNames.refresh, refresh);
    set(KeyValueNames.loggedIn, "true");
  }
}
