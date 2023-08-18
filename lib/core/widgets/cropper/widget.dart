import 'package:crop_your_image/crop_your_image.dart';
import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Cropper extends StatefulWidget {
  final Uint8List image;
  final ValueChanged<Uint8List> onCropped;

  const Cropper({
    super.key,
    required this.image,
    required this.onCropped,
  });

  @override
  State<StatefulWidget> createState() => CropperState();
}

class CropperState extends State<Cropper> {
  final CropController cropController = CropController();
  bool preview = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => setState(() => preview = !preview),
                icon: Icon(
                  !preview ? ThemeIcons.lock : ThemeIcons.lockOpen,
                  color: themeTextColor,
                ),
              ),
            ),
            Visibility(
              visible: preview,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => cropController.crop(),
                  icon: Icon(
                    ThemeIcons.check,
                    color: themeTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Crop(
            image: widget.image,
            controller: cropController,
            maskColor: preview ? Colors.white : null,
            fixArea: preview,
            cornerDotBuilder: (size, edgeAlignment) => preview //
                ? const SizedBox.shrink()
                : const DotControl(),
            baseColor: Theme.of(context).scaffoldBackgroundColor,
            initialSize: 0.5,
            radius: 0,
            onCropped: widget.onCropped,
          ),
        ),
      ],
    );
  }
}
