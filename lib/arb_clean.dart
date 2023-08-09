// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

const lineNumber = 'line-number';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  final terms = getTranslationTerms();
  final dartFiles = getDartFiles();
  final notUsed = findNotUsedArbTerms(terms, dartFiles);
  if (notUsed.isNotEmpty) {
    File("lib/l10n/unused.txt").writeAsStringSync(notUsed.join("\n"));
  } else {
    File("lib/l10n/unused.txt").writeAsStringSync("");
  }
}

Set<String> getTranslationTerms() {
  final arbFile = Glob("lib/**.arb");
  final arbFiles = <FileSystemEntity>[];
  for (var entity in arbFile.listSync(followLinks: false)) {
    arbFiles.add(entity);
  }

  final arbTerms = <String>{};

  for (final file in arbFiles) {
    final content = File(file.path).readAsStringSync();
    final map = jsonDecode(content) as Map<String, dynamic>;
    for (final entry in map.entries) {
      if (!entry.key.startsWith('@')) {
        arbTerms.add(entry.key);
      }
    }
  }
  return arbTerms;
}

List<FileSystemEntity> getDartFiles() {
  final dartFile = Glob("lib/**.dart");

  final dartFiles = <FileSystemEntity>[];
  for (var entity in dartFile.listSync(followLinks: false)) {
    if (!entity.path.contains("l10n/translations")) {
      dartFiles.add(entity);
    }
  }

  return dartFiles;
}

Set<String> findNotUsedArbTerms(
  Set<String> arbTerms,
  List<FileSystemEntity> files,
) {
  final unused = arbTerms.toSet();
  for (final file in files) {
    final content = File(file.absolute.path).readAsStringSync();
    for (final arb in arbTerms) {
      if (content.contains(arb)) {
        unused.remove(arb);
      }
    }
  }
  return unused;
}
