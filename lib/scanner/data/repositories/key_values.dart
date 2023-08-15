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
  Future<void> close() => _box.close();

  @override
  Future<void> init() async {
    await setAreaItems([
      "archived;de:Archiv;en:Archive",
      "cards;de:Karten;en:Cards",
      "commercial;de:Handel;en:Commercial",
      "common;de:Allgemein;en:Common",
      "financial;de:Finanzen;en:Financial",
      "insurance;de:Versicherung;en:Insurance",
      "private;de:Privat;en:Private",
      "tax;de:Steuer;en:Tax",
      "traveling;de:Reisen;en:Traveling",
    ]);

    await setDocumentTypeItems([
      "bankDocument;de:Bankunterlagen;en:Bank document",
      "birthCertificate;de:Geburtsurkunde;en:Birth certificate",
      "business;de:Geschäftliche;en:Business",
      "children;de:Kinder;en:Children",
      "contract;de:Vertrag;en:Contract",
      "correspondence;de:Korrespondenz;en:Correspondence",
      "craftInstruction;de:Bastelanleitung;en:Craft instruction",
      "deathCertificate;de:Sterbeurkunde;en:Death certificate",
      "deliveryNote;de:Lieferschein;en:Delivery note",
      "gardenPlan;de:Gartenplan;en:Garden plan",
      "hobbies;de:Hobby;en:Hobbies",
      "identificationDocument;de:Ausweisdokument;en:Identification document",
      "insurance;de:Versicherung;en:Insurance",
      "invoice;de:Rechnung;en:Invoice",
      "statementOfAccount;de:Kontoauszug;en:Statement of account",
      "marriageCertificate;de:Heiratsurkunde;en:Marriage certificate",
      "music;de:Musik;en:Music",
      "orderConfirmation;de:Auftragsbestätigung;en:Order confirmation",
      "other;de:Sonstiges;en:Other",
      "personal;de:Persönliche;en:Personal",
      "pets;de:Haustier;en:Pets",
      "photo;de:Foto;en:Photo",
      "presentation;de:Präsentation;en:Presentation",
      "recipes;de:Rezepte;en:Recipes",
      "reports;de:Berichte;en:Reports",
      "sportsResult;de:Sportergebnis;en:Sports result",
      "taxDocument;de:Steuerunterlagen;en:Tax document",
      "travelDocument;de:Reiseunterlagen;en:Travel document",
      "video;de:Video;en:Video",
    ]);
  }
}
