// ignore: depend_on_referenced_packages
import 'package:document_scanner/scanner/application.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:flutter/material.dart';

class DocumentScanner extends Application {
  DocumentScanner({super.key});

  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends ApplicationState<DocumentScanner> {
  @override
  final routes = {ScannerScreen.route};

  @override
  String get initialRoute => ScannerScreen.path;
}
