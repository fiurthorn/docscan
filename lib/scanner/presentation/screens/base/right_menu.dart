import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/domain/usecases/export_database.dart';
import 'package:document_scanner/scanner/presentation/screens/areas/page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/base_right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/menu_item.dart';
import 'package:document_scanner/scanner/presentation/screens/documentsTypes/page.dart';
import 'package:document_scanner/scanner/presentation/screens/receiver/page.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:document_scanner/scanner/presentation/screens/sender/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RightMenu extends BaseMenu {
  const RightMenu({
    required super.refresh,
    super.logout = true,
    super.key,
  });

  @override
  List<Widget> menuItems(BuildContext context) => [
        ListTile(
          title: const Text("docscan"),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: themeGrey4Color,
            child: ThemeIcons.logo2(color: nord4SnowStorm),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 1, height: 2),
        const SizedBox(height: 10),
        ListTile(
          title: Text(AppLang.i18n.scanner_page_title),
          leading: Icon(ThemeIcons.scanner, color: themeGrey4Color),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            context.go(ScannerScreen.path);
          },
        ),
        const Divider(thickness: 1, height: 2),
        ListTile(
          title: Text(AppLang.i18n.areas_page_title),
          leading: Icon(ThemeIcons.area, color: themeGrey4Color),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            context.go(AreasScreen.path);
          },
        ),
        ListTile(
          title: Text(AppLang.i18n.docTypes_page_title),
          leading: Icon(ThemeIcons.docType, color: themeGrey4Color),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            context.go(DocumentTypesScreen.path);
          },
        ),
        ListTile(
          title: Text(AppLang.i18n.senders_page_title),
          leading: Icon(ThemeIcons.envelopeOpenText, color: themeGrey4Color),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            context.go(SendersScreen.path);
          },
        ),
        ListTile(
          title: Text(AppLang.i18n.receivers_page_title),
          leading: Icon(ThemeIcons.envelopeOpenText, color: themeGrey4Color),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            context.go(ReceiversScreen.path);
          },
        ),
      ];

  @override
  List<Widget> accountItems(BuildContext context) => <Widget>[
        ListTile(
          title: const Text("Export database"),
          leading: Icon(ThemeIcons.database, color: themeGrey4Color),
          onTap: () {
            usecase<bool, ExportDatabaseParam>(ExportDatabaseParam())
                .then(
                  (value) => showSnackBarSuccess(context, "export", "Database exported successfully."),
                )
                .onError((error, stackTrace) => showSnackBarFailure(
                    context, "export", "Error while exporting database.", error,
                    stackTrace: stackTrace));
            Scaffold.of(context).closeEndDrawer();
            context.go(SendersScreen.path);
          },
        )
      ];

  Widget menuItem(MenuItem item) => Builder(builder: (context) {
        return ListTile(
          title: Text(item.title),
          leading: item.icon,
          onTap: () {
            item.action(context);
            if (item.closeDrawer) {
              Scaffold.of(context).closeEndDrawer();
            }
          },
        );
      });
}
