import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/toaster/failure_banner.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/domain/usecases/export_database.dart';
import 'package:document_scanner/scanner/presentation/screens/areas/page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/default_right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/menu_item.dart';
import 'package:document_scanner/scanner/presentation/screens/documentsTypes/page.dart';
import 'package:document_scanner/scanner/presentation/screens/receivers/page.dart';
import 'package:document_scanner/scanner/presentation/screens/senders/page.dart';
import 'package:flutter/material.dart';

class ScannerRightMenu extends DefaultRightMenu {
  final List<Widget> additionalMenuItems;
  final List<Widget> additionalAccountItems;

  const ScannerRightMenu({
    super.logout = true,
    super.key,
    this.additionalMenuItems = const [],
    this.additionalAccountItems = const [],
  });

  @override
  List<Widget> menuItems(BuildContext context) {
    final foregroundColor = Theme.of(context).primaryColor;

    return [
      ListTile(
        title: const Text("docscan"),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: foregroundColor,
          child: ThemeIcons.logo2(
            color: Theme.of(context).colorScheme.onPrimary,
            height: 40,
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Divider(thickness: 1, height: 2),
      ListTile(
        title: Text(AppLang.i18n.areas_page_title),
        leading: Icon(ThemeIcons.area, color: foregroundColor),
        onTap: () {
          push(context, AreasScreen.path);
        },
      ),
      ListTile(
        title: Text(AppLang.i18n.senders_page_title),
        leading: Icon(ThemeIcons.envelopeSender, color: foregroundColor),
        onTap: () {
          push(context, SendersScreen.path);
        },
      ),
      ListTile(
        title: Text(AppLang.i18n.receivers_page_title),
        leading: Icon(ThemeIcons.envelopeReceiver, color: foregroundColor),
        onTap: () {
          push(context, ReceiversScreen.path);
        },
      ),
      ListTile(
        title: Text(AppLang.i18n.docTypes_page_title),
        leading: Icon(ThemeIcons.docType, color: foregroundColor),
        onTap: () {
          push(context, DocumentTypesScreen.path);
        },
      ),
      for (final w in additionalMenuItems) w,
    ];
  }

  @override
  List<Widget> accountItems(BuildContext context) {
    final foregroundColor = Theme.of(context).primaryColor;

    return <Widget>[
      ListTile(
        title: const Text("Export database"),
        leading: Icon(ThemeIcons.database, color: foregroundColor),
        onTap: () {
          usecase<ExportDatabaseResult, ExportDatabaseParam>(ExportDatabaseParam())
              .then(
                (value) => showSnackBarSuccess(context, "Database exported successfully."),
              )
              .onError(
                (err, stackTrace) => showBannerFailure(context, "export",
                    message: "Error while exporting database.", failure: err, stackTrace: stackTrace),
              );
          Scaffold.of(context).closeEndDrawer();
          // context.go(SendersScreen.path);
        },
      ),
      for (final w in additionalAccountItems) w,
    ];
  }

  Widget menuItem(MenuItem item) => Builder(
        builder: (context) {
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
        },
      );
}
