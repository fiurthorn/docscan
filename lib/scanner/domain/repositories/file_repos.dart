import 'dart:typed_data';

import 'package:document_scanner/core/lib/tuple.dart';
import 'package:image_picker/image_picker.dart';

abstract class FileRepos {
  List<Tuple2<String, Uint8List>> readFiles(List<String> paths);
  Tuple2<String, Uint8List> readFile(String path);
  Future<Tuple2<String, Uint8List>> readXFile(XFile path);
}
