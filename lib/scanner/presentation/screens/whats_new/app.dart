import 'package:document_scanner/core/design/theme_data.dart';
import 'package:document_scanner/scanner/presentation/screens/whats_new/page.dart';
import 'package:flutter/material.dart';

class WhatsNew extends StatelessWidget {
  const WhatsNew({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        showSemanticsDebugger: false,
        theme: theme(),
        home: const WhatsNewDialog(),
      );
}
