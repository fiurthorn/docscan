import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/domain/repositories/file_repos.dart';
import 'package:document_scanner/scanner/domain/repositories/models/read_file.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FileReposImpl implements FileRepos {
  Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables) sync* {
    if (iterables.isEmpty) return;
    final iterators = iterables.map((e) => e.iterator).toList(growable: false);
    while (iterators.every((e) => e.moveNext())) {
      yield iterators.map((e) => e.current).toList(growable: false);
    }
  }

  @override
  List<ReadFileModel> readFiles(List<String> paths) {
    final content = paths.map((e) => sl<FileSource>().readFile(e)).toList();
    return zip([paths, content]).map((e) => ReadFileModel(e[0] as String, e[1] as Uint8List)).toList();
  }

  @override
  ReadFileModel readFile(String path) {
    return ReadFileModel(path, sl<FileSource>().readFile(path));
  }

  @override
  String readFileAsString(String path) {
    return sl<FileSource>().readFileAsString(path);
  }

  @override
  Future<ReadFileModel> readXFile(XFile file) {
    return sl<FileSource>().readXFile(file).then((value) => ReadFileModel(file.name, value));
  }
}
