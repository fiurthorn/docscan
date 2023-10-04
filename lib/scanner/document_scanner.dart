// ignore: depend_on_referenced_packages
import 'package:document_scanner/scanner/application.dart';
import 'package:document_scanner/scanner/presentation/screens/areas/page.dart';
import 'package:document_scanner/scanner/presentation/screens/documentsTypes/page.dart';
import 'package:document_scanner/scanner/presentation/screens/receivers/page.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:document_scanner/scanner/presentation/screens/senders/page.dart';
import 'package:flutter/material.dart';

class DocumentScanner extends Application {
  DocumentScanner({super.key});

  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends ApplicationState<DocumentScanner> {
  @override
  final routes = {
    ScannerScreen.route,
    AreasScreen.route,
    DocumentTypesScreen.route,
    SendersScreen.route,
    ReceiversScreen.route,
  };

  @override
  String get initialRoute => ScannerScreen.path;
}
