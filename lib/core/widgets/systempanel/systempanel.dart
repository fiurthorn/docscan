import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/platform/platform.dart';
import 'package:document_scanner/core/version.g.dart';
import 'package:document_scanner/core/widgets/hover_icon_button/widget.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/scanner/application.dart';
import 'package:document_scanner/scanner/domain/usecases/import_database.dart';
import 'package:document_scanner/scanner/presentation/screens/whats_new/page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SystemPanel extends StatelessWidget {
  const SystemPanel({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _importDatabaseButton(
                ThemeIcons.fileImport,
                ThemeIcons.fileImport,
                "Import Database",
                () {
                  LoadingDialog.show(context);
                  FilePicker.platform
                      .pickFiles(
                        allowMultiple: false,
                        dialogTitle: "Database file",
                      )
                      .then((result) => result?.files.single.path)
                      .then(
                    (path) {
                      if (path != null) {
                        usecase<ImportDatabaseResult, ImportDatabaseParam>(ImportDatabaseParam(path));
                      }
                    },
                  ).whenComplete(() => LoadingDialog.hide(context));
                },
              ),
              _whatsNewButton(
                ThemeIcons.newspaper,
                ThemeIcons.newspaper,
                "What's new",
                () => showDialog(
                  context: context,
                  builder: (context) => WhatsNewDialog(
                    onClose: () => Navigator.pop(context),
                  ),
                ),
              ),
              _reloadButton(
                ThemeIcons.reload,
                ThemeIcons.reload,
                "Restart App",
                () => Application.restartApp(context),
              ),
            ],
          ),
          _fragment(platformDescription),
          _miniFragment(buildDate.toIso8601String().substring(0, 19)),
        ],
      );

  Widget _importDatabaseButton(IconData brand, IconData hover, String tip, VoidCallback onPressed) => HoverIconButton(
        icon: brand,
        hoverIcon: hover,
        tooltip: tip,
        size: 20,
        color: nord0PolarNight,
        onPressed: onPressed,
      );

  Widget _reloadButton(IconData brand, IconData hover, String tip, VoidCallback onPressed) => HoverIconButton(
        icon: brand,
        hoverIcon: hover,
        tooltip: tip,
        size: 20,
        color: nord0PolarNight,
        onPressed: onPressed,
      );

  Widget _whatsNewButton(IconData brand, IconData hover, String tip, VoidCallback onPressed) => HoverIconButton(
        icon: brand,
        hoverIcon: hover,
        tooltip: tip,
        size: 20,
        color: nord0PolarNight,
        onPressed: onPressed,
      );

  Widget _fragment(String msg) => Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Text(msg, style: const TextStyle(color: nord1PolarNight)),
      );

  Widget _miniFragment(String msg) => Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Text(msg, style: const TextStyle(color: nord1PolarNight, fontSize: 12)),
      );
}
