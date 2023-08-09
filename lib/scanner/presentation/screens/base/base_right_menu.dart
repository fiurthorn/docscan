import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/language_name.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';

Drawer baseRightMenu(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffold,
  Function reloader, {
  List<Widget> menuItems = const <Widget>[],
  List<Widget> accountItems = const <Widget>[],
}) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: Column(children: menuItems),
          ),
          if (accountItems.isNotEmpty) const Divider(thickness: 1, height: 2),
          Column(children: accountItems),
          const Divider(thickness: 1, height: 2),
          ListTile(
            leading: Icon(ThemeIcons.lang),
            title: DropdownButton<String>(
              value: AppLang.lang,
              underline: Container(),
              items: sortedLanguageNames
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.code,
                      child: Text(e.name, style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                AppLang.lang = newValue!;
                scaffold.currentState!.closeEndDrawer();
                reloader();
              },
            ),
          ),
          const Divider(thickness: 1, height: 2),
        ],
      ),
    ),
  );
}
