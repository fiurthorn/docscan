import 'package:document_scanner/core/design/theme_data.dart';
import 'package:document_scanner/core/lib/whatsnew/items.dart';
import 'package:document_scanner/core/lib/whatsnew/list.dart';
import 'package:flutter/material.dart';

class WhatsNew extends StatelessWidget {
  const WhatsNew({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: theme(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('What\'s New'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: WhatsNewList(
              items: [
                HeadingItem("v0.1.5"),
                MessageItem("Packaging", "CI/CD Build und Packaging"),
                HeadingItem("v0.1.4"),
                MessageItem("Layout", "Buttons neu ausgerichtet"),
                MessageItem("Back", "Zurück schließt den Dialog nicht die App"),
                HeadingItem("v0.1.3"),
                MessageItem("Layout", "Layout neu ausgerichtet"),
                MessageItem("What's new", "Neuer Dialog"),
                HeadingItem("v0.1.2"),
                MessageItem("Theme", "Nord-Theme auf die App ausgerollt"),
                MessageItem("i18n", "Beschriftungen angepasst"),
                HeadingItem("v0.1.1"),
                MessageItem("What's new", "dieser Dialog"),
                HeadingItem("v0.1.0"),
                MessageItem("DropDown-Listen", "Live-Aktualisierung der Listeneinträge"),
              ],
            ),
          ),
          persistentFooterAlignment: AlignmentDirectional.center,
          persistentFooterButtons: [
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
