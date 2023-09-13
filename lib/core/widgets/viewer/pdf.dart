import 'package:document_scanner/core/widgets/viewer/viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends DocumentViewer {
  final PdfControllerPinch _controller;

  PdfViewer(super.filename, super.data, {super.key})
      : _controller = PdfControllerPinch(document: PdfDocument.openData(data));

  @override
  bool get downloadAction => true;

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              previous,
              pageCount,
              next,
            ],
          ),
          Expanded(
            child: PdfViewPinch(
              controller: _controller,
              builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
                pageLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
                // pageBuilder: _pageBuilder,
              ),
            ),
          ),
        ],
      );

  Widget get pageCount => PdfPageNumber(
        controller: _controller,
        builder: (_, loadingState, page, pagesCount) => Container(
          alignment: Alignment.center,
          child: Text(
            '$page/${pagesCount ?? 0}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );

  void nextAction() => _controller.nextPage(curve: Curves.ease, duration: const Duration(milliseconds: 100));
  void previousAction() => _controller.previousPage(curve: Curves.ease, duration: const Duration(milliseconds: 100));

  Widget get next => IconButton(icon: const Icon(Icons.navigate_next), onPressed: nextAction);
  Widget get previous => IconButton(icon: const Icon(Icons.navigate_before), onPressed: previousAction);

//   PhotoViewGalleryPageOptions _pageBuilder(
//     BuildContext context,
//     Future<PdfPageImage> pageImage,
//     int index,
//     PdfDocument document,
//   ) {
//     return PhotoViewGalleryPageOptions(
//       imageProvider: PdfPageImageProvider(
//         pageImage,
//         index,
//         document.id,
//       ),
//       minScale: PhotoViewComputedScale.contained * 1,
//       maxScale: PhotoViewComputedScale.contained * 2,
//       initialScale: PhotoViewComputedScale.contained * 1.0,
//       heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
//     );
//   }
}
