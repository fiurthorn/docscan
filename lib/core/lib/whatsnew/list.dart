import 'package:document_scanner/core/lib/whatsnew/items.dart';
import 'package:flutter/material.dart';

class WhatsNewList extends StatelessWidget {
  final List<ListItem> items;

  const WhatsNewList({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
          trailing: const SizedBox(height: 0),
          contentPadding: const EdgeInsets.all(0),
          horizontalTitleGap: 0,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          //dense: true,
        );
      },
    );
  }
}
