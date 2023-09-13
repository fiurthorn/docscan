import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/language_name.dart';
import 'package:document_scanner/core/version.g.dart';
import 'package:document_scanner/core/widgets/systempanel/systempanel.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';

class BaseMenu extends StatelessWidget {
  final Function refresh;
  final bool logout, about;

  List<Widget> menuItems(BuildContext context) => const [];
  List<Widget> accountItems(BuildContext context) => const [];

  const BaseMenu({
    required this.refresh,
    this.about = true,
    this.logout = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(
                child: Column(children: menuItems(context)),
              ),
              ...accountItems(context),
              const Divider(thickness: 1, height: 2),
              ListTile(
                leading: Icon(ThemeIcons.lang, color: themeGrey4Color),
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
                    Scaffold.of(context).closeEndDrawer();
                    refresh();
                  },
                ),
              ),
              const Divider(thickness: 1, height: 2),
              ListTile(
                leading: Icon(ThemeIcons.info, color: themeGrey4Color),
                title: Text(AppLang.i18n.baseScreen_about_label('docscan')),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: themeGrey4Color),
                          ),
                          child: ThemeIcons.logo2(
                            height: 100,
                            color: themeGrey4Color,
                          )),
                      applicationName: 'docscan',
                      applicationVersion: buildVersion,
                      applicationLegalese: copyright,
                      children: [const RuntimeWidget()]);

                  Scaffold.of(context).closeEndDrawer();
                },
              ),
              const Divider(thickness: 1, height: 2),
            ],
          ),
        ),
      );
}
