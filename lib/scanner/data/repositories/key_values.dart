import 'dart:convert';
import 'dart:io';

import 'package:document_scanner/core/lib/trace.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/version.g.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/data/datasources/native.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:hive/hive.dart';

class KeyValuesImpl implements KeyValues {
  late final Box _box;

  KeyValuesImpl(Box keyValues) : _box = keyValues;

  @override
  bool flag(KeyValueNames key) => get(key, "false") == "true";

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
  Future<void> addSenderName(String senderName) async {
    if (!_box.containsKey(KeyValueNames.senderNames.name)) {
      _box.put(KeyValueNames.senderNames.name, [senderName]);
      return;
    }

    final items = getItems(KeyValueNames.senderNames);
    if (!items.contains(senderName)) {
      items
        ..add(senderName)
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      _box.put(KeyValueNames.senderNames.name, items);
    }

    return;
  }

  @override
  List<String> getItems(KeyValueNames key) =>
      (_box.get(key.name, defaultValue: const []) as List).map((e) => '$e').toList();

  @override
  Future<void> setItems(KeyValueNames key, List<String> list) {
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return _box.put(key.name, list);
  }

  @override
  Future<void> close() => _box.close();

  @override
  bool hasNewBuildNumber() {
    return num.parse(get(KeyValueNames.lastBuildNumber, "-1")) < buildNumber;
  }

  @override
  void resetBuildNumber() {
    set(KeyValueNames.lastBuildNumber, "$buildNumber");
  }

  @override
  void clear() {
    set(KeyValueNames.lastBuildNumber, "0");
  }

  @override
  Future<void> importDatabase(Map<dynamic, dynamic> map) {
    return Future.wait(
      map.entries.map(
        (e) => _box.put(KeyValueNames.values.firstWhere((key) => key.name == e.key).name, e.value),
      ),
    );
  }

  @override
  Future<void> exportDatabase() async {
    final tmpDir = await sl<FileSource>().getTempDir();
    final file = File("$tmpDir/database.json");

    return file
        .writeAsString(trace(json.encode(_box.toMap()), "database"))
        .then(
          (value) => sl<Native>().saveFileInMediaStore(
            file.absolute.path,
            "database",
            "content.json",
          ),
        )
        .then((value) => file.delete());
  }

  @override
  Future<void> init() async {
    if (trace(!flag(KeyValueNames.listsInitOnStartup), "!flag(KeyValueNames.listsInitOnStartup)")) {
      set(KeyValueNames.listsInitOnStartup, "true");

      await setItems(KeyValueNames.areas, [
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

      await setItems(KeyValueNames.documentTypes, [
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
        "prescription;de:Rezept;en:Prescription",
        "presentation;de:Präsentation;en:Presentation",
        "recipe;de:Quittung;en:Recipe",
        "reports;de:Berichte;en:Reports",
        "sportsResult;de:Sportergebnis;en:Sports result",
        "taxDocument;de:Steuerunterlagen;en:Tax document",
        "travelDocument;de:Reiseunterlagen;en:Travel document",
        "video;de:Video;en:Video",
      ]);
    }
  }
}
