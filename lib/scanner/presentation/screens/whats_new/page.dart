import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class WhatsNewDialog extends StatelessWidget {
  final VoidCallback? onClose;

  const WhatsNewDialog({
    this.onClose,
    super.key,
  });

  static const String path = '/whatsnew';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        name: path,
        child: (context, state) => const WhatsNewDialog(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('What\'s New'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: sl<FileSource>().assetFileAsString("ChangeLog.md"),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data == null) return const CircularProgressIndicator();

                return Markdown(
                  data: snapshot.data!,
                );
              }),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              sl<KeyValues>().resetBuildNumber();
              if (onClose != null) {
                onClose?.call();
              } else {
                context.go(ScannerScreen.path);
              }
            },
          ),
        ],
      );
}
