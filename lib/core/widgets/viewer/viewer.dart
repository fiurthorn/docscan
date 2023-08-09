import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/viewer/image.dart';
import 'package:document_scanner/core/widgets/viewer/pdf.dart';

abstract class DocumentViewer extends StatelessWidget {
  final Uint8List data;
  final String filename;

  const DocumentViewer(this.filename, this.data, {super.key});

  @override
  Widget build(BuildContext context);
  void dispose();

  bool get downloadAction;

  static bool isPdf(String filename) => filename.endsWith('.pdf');
  static bool isImage(String filename) =>
      ['.jpeg', '.jpg', '.png', '.gif', '.webp', '.bmp', '.wbmp'].any((ext) => filename.endsWith(ext));

  static DocumentViewer viewer(String filename, Uint8List data) {
    if (isPdf(filename)) {
      return PdfViewer(filename, data);
    } else if (isImage(filename)) {
      return ImageViewer(filename, data);
    } else {
      return DownloaderViewer(filename, data);
    }
  }

  static bool supported(String filename) => isPdf(filename.toLowerCase()) || isImage(filename.toLowerCase());
}

class DownloaderViewer extends DocumentViewer {
  const DownloaderViewer(super.filename, super.data, {super.key});

  @override
  bool get downloadAction => false;

  @override
  Widget build(BuildContext context) => Center(
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: themeTextColor,
              backgroundColor: themeGrey4Color,
            ),
            onPressed: () {
              FileSaver.instance.saveFile(
                name: filename,
                bytes: data,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(ThemeIcons.fileDownload, size: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(filename),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {}
}
