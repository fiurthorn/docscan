import 'package:document_scanner/core/widgets/viewer/viewer.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends DocumentViewer {
  const ImageViewer(super.filename, super.data, {super.key});

  @override
  bool get downloadAction => true;

  @override
  Widget build(BuildContext context) => PhotoView(
        imageProvider: MemoryImage(data),
        backgroundDecoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      );

  @override
  void dispose() {}
}
