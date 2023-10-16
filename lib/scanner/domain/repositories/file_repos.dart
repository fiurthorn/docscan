import 'package:document_scanner/scanner/domain/repositories/models/read_file.dart';
import 'package:image_picker/image_picker.dart';

abstract class FileRepos {
  List<ReadFileModel> readFiles(List<String> paths);
  ReadFileModel readFile(String path);
  String readFileAsString(String path);
  Future<ReadFileModel> readXFile(XFile path);
}
